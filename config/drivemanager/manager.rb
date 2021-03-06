require 'google/apis/drive_v3'
require 'googleauth'

# Module for Google Drive API interaction
module DriveManager
  # Class for authenticating a Google Drive service object
  class Manager
    class << self; attr_accessor :request_queue end
    attr_accessor :service
    @last_request = Time.now.to_f
    @request_mutex = Mutex.new

    def initialize
      @service = authorize_service(Google::Apis::DriveV3::DriveService.new)
    end

    # Pull private key ID and private key from environment variables.
    KEY_FILE = 'client_secret.json'.freeze
    CLIENT_SECRET = {
      'type' => 'service_account',
      'project_id' => ENV['LC_PROJECT_ID'],
      'private_key_id' => ENV['LC_PRIVATE_KEY_ID'],
      'private_key' => ENV['LC_PRIVATE_KEY1'] + ENV['LC_PRIVATE_KEY2'],
      'client_email' => ENV['LC_CLIENT_EMAIL'],
      'client_id' => ENV['LC_CLIENT_ID'],
      'auth_uri' => 'https://accounts.google.com/o/oauth2/auth',
      'token_uri' => 'https://accounts.google.com/o/oauth2/token',
      'auth_provider_x509_cert_url' => 'https://www.googleapis.com/oauth2/v1/certs',
      'client_x509_cert_url' => ENV['LC_CERT_URL']
    }.freeze

    # Use the generated client_secret.json file to authenticate the Google Drive service object.
    def authorize_service(service)
      scopes = ['https://www.googleapis.com/auth/drive']
      File.open('client_secret.json'.to_s, 'r') do |json_io|
        service.authorization = Google::Auth::DefaultCredentials.make_creds(
          scope: scopes,
          json_key_io: json_io
        )
        return service
      end
    end

    # Create the client_secret file using the private key information.
    def self.create_client_secret_file
      File.exist?(KEY_FILE.to_s) && File.delete(KEY_FILE.to_s)
      File.open(KEY_FILE.to_s, 'w') do |f|
        f.write(CLIENT_SECRET.to_json.gsub('\\\\', '\\'))
      end
    end

    def self.sleep_until_turn
      loop do
        @request_mutex.synchronize do
          if Time.now.to_f - @last_request > 0.1
            @last_request = Time.now.to_f
            return
          end
        end
        sleep 0.1
      end
    end
  end
end
