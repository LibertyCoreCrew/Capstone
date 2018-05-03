require_relative './manager.rb'
require_relative './drivenlp.rb'
require 'pdf-reader'
require 'roo'
require 'roo-xls'
require 'tempfile'
require 'docx'
require 'msworddoc-extractor'
require 'ruby-rtf'
require 'ruby_powerpoint'

module DriveManager
  # Strategy:
  #  Get list of files with list_files
  #     https://developers.google.com/drive/v3/web/search-parameters#file_fields
  #  Check list to see if any have been edited since being added to the database
  #  For files that have been changed or added, use About to check exportFormats
  #     https://developers.google.com/drive/v3/reference/about
  #     https://stackoverflow.com/questions/39669343/download-a-file-from-google-drive-using-google-api-ruby-client?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  #  Use get_file with the appropriate format to download the file into a StringIO
  #     https://developers.google.com/drive/v3/web/manage-downloads
  #  Run natural language processing on the contents and title of the document to extract keywords
  #  Record in database:
  #     - file name
  #     - file id
  #     - time of last file edit
  #     - keywords/proper nouns
  #  Check projects to see if any keywords match
  #  If it meets a given threshold, associate the file id with the project in the project's database
  #  Display files for a given project in a file picker on the bottom of the project page
  #     This will be managed in the controller for the project page

  # Class for retrieving file list and contents from Google Drive
  class DriveAPI
    # Got some of the code from here:
    # https://github.com/google/google-api-ruby-client/blob/master/samples/cli/lib/samples/drive.rb
    # Once we implement a database to record whether files have already been checked, this method
    # will just loop repeatedly to check for newly updated or added files to be parsed.
    def self.nlp_file_monitoring
      drive = Manager.new.service

      limit = 10_000
      page_token = nil

      loop do
        Manager.sleep_until_turn
        result = drive.list_files(page_size: [limit, 100].min,
                                  page_token: page_token,
                                  fields: 'files(id,name,mime_type,modified_time,file_extension,web_view_link),next_page_token')

        result.files.each do |file|
          puts "#{file.id}, #{file.name}, #{file.mime_type}, #{file.modified_time}, #{file.web_view_link}"
          next if file.mime_type == 'application/vnd.google-apps.folder'
          f = GoogleFile.find_by( google_id: file.id )
          next unless f.nil? || f.last_change < file.modified_time
          content = extract_text(drive, file)
          # puts content + "\n\n"
          DriveNLP.process(file, content)
        end

        # Break once we hit the limit or have run out of pages
        limit -= result.files.length
        page_token = result.next_page_token
        break unless page_token && limit > 0
      end
    end

    def self.extract_text(drive, file)
      Manager.sleep_until_turn
      type = file.mime_type
      roo_xls = %w[
        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
        text/csv
        application/vnd.ms-excel
        application/vnd.ms-excel.sheet.macroenabled.12
      ]
      content = if type == 'application/vnd.google-apps.document'
                  drive.export_file(file.id, 'text/plain', download_dest: StringIO.new).string
                elsif type == 'application/vnd.google-apps.spreadsheet'
                  drive.export_file(file.id, 'text/csv', download_dest: StringIO.new).string
                elsif type == 'application/vnd.google-apps.presentation'
                  drive.export_file(file.id, 'text/plain', download_dest: StringIO.new).string
                elsif type == 'text/plain'
                  drive.get_file(file.id, download_dest: StringIO.new).string
                elsif type == 'application/pdf'
                  pdf = drive.get_file(file.id, download_dest: StringIO.new)
                  parse_pdf(pdf)
                elsif roo_xls.include?(type)
                  temp = Tempfile.new(['temp', ".#{file.file_extension}"])
                  drive.get_file(file.id, download_dest: temp.path)
                  parse_xlsx_xls_csv(temp, file.file_extension)
                elsif type == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                  temp = Tempfile.new(['temp', ".#{file.file_extension}"])
                  drive.get_file(file.id, download_dest: temp.path)
                  process_docx(temp)
                elsif type == 'application/msword' && file.file_extension == 'doc'
                  temp = Tempfile.new(['temp', ".#{file.file_extension}"])
                  drive.get_file(file.id, download_dest: temp.path)
                  process_doc(temp)
                elsif type == 'application/msword' && file.file_extension == 'rtf'
                  temp = Tempfile.new(['temp', ".#{file.file_extension}"])
                  drive.get_file(file.id, download_dest: temp.path)
                  process_rtf(temp)
                elsif type == 'application/vnd.openxmlformats-officedocument.presentationml.presentation' && file.file_extension == 'pptx'
                  temp = Tempfile.new(['temp', ".#{file.file_extension}"])
                  drive.get_file(file.id, download_dest: temp.path)
                  process_pptx(temp)
                else
                  ''
                end
      content.gsub!(/[^0-9a-z\.\!\?\'\"\[\]\(\)\$ ]/i, ' ')
      content
    end

    def self.parse_pdf(pdf)
      reader = PDF::Reader.new(pdf)
      content = ''
      limit = [10, reader.page_count].min
      reader.pages.each do |page|
        content << page.text
        limit -= 1
        break if limit.zero?
      end
      content
    rescue PDF::MalformedPDFError, PDF::UnsupportedFeatureError => e
      puts e
      puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      puts e.class
      ''
    end

    def self.parse_xlsx_xls_csv(temp, extension)
      xlsx = Roo::Spreadsheet.open(temp.path, extension: extension)
      content = ''
      limit = [10, xlsx.sheets.count].min
      xlsx.sheets.each do |sheet_name|
        xlsx.sheet(sheet_name).each do |row|
          row.each do |value|
            content << "#{value} " if value.to_s != ''
          end
        end
        limit -= 1
        break if limit.zero?
      end
      temp.close
      temp.unlink
      content
    end

    def self.process_docx(temp)
      doc = Docx::Document.open(temp.path)
      content = ''
      return content unless doc
      doc.paragraphs.each { |p| content << p.to_s }
      temp.close
      temp.unlink
      content
    end

    def self.process_doc(temp)
      content = ''
      MSWordDoc::Extractor.load(temp.path) do |doc|
        content << doc.whole_contents.to_s + ' '
      end
      temp.close
      temp.unlink
      content
    end

    def self.process_rtf(temp)
      data = File.open(temp).read
      puts 'Ignore any errors below:'
      doc = RubyRTF::Parser.new.parse(data)
      puts ''
      content = ''
      doc.sections.each { |sect| content << sect[:text].to_s }
      content ||= ''
      temp.close
      temp.unlink
      content
    rescue RubyRTF::InvalidDocument => e
      puts e
      puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      puts e.class
      ''
    end

    def self.process_pptx(temp)
      deck = RubyPowerpoint::Presentation.new temp.path
      content = ''
      deck.slides.each do |slide|
        content << slide.title + ' '
        slide.content.each { |cont| content << cont + ' ' }
      end
      temp.close
      temp.unlink
      content
    end
  end
end
