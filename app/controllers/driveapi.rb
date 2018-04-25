module DriveManager
  # Class for interacting with the Google Drive API
  class DriveAPI
    def self.test_method(service)
      result = service.list_files(page_size: 10, fields: 'nextPageToken, files(id, name)')
      result.files.each do |file|
        puts "File name: #{file.name}"
      end
    end
  end
end
