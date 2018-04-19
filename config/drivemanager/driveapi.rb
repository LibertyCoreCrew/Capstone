require_relative './manager.rb'
require_relative './drivenlp.rb'

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
    def self.nlp_file_monitoring
      drive = Manager.new.service

      limit = 10_000
      page_token = nil
      loop do
        result = drive.list_files(page_size: [limit, 100].min,
                                  page_token: page_token,
                                  fields: 'files(id,name,mime_type,modified_time),next_page_token')

        result.files.each do |file|
          puts "#{file.id}, #{file.name}, #{file.mime_type}, #{file.modified_time}"
          dest = StringIO.new
          # drive.get_file(file.id, download_dest: dest)
          # puts dest.string
          DriveNLP.process(file, dest.string)
        end

        # Break once we hit the limit or have run out of pages
        limit -= result.files.length
        page_token = result.next_page_token
        break unless page_token && limit > 0
      end
    end
  end
end
