require 'google/apis/drive_v3'
require 'googleauth'

module DriveManager
  # Class for interacting with the Google Drive API
  class Manager
    attr_accessor :service

    def initialize
      @service = authorize_service(Google::Apis::DriveV3::DriveService.new)
    end

    private

    # Pull private key ID and private key from environment variables.
    PROJECT_ID = 'lc-docs-development'.freeze
    KEY_FILE = 'client_secret.json'.freeze
    CLIENT_SECRET = {
      'type' => 'service_account',
      'project_id' => PROJECT_ID,
      'private_key_id' => ENV['LC_PRIVATE_KEY_ID'],
      'private_key' => ENV['LC_PRIVATE_KEY1'] + ENV['LC_PRIVATE_KEY2'],
      'client_email' => 'lc-docs-service@lc-docs-development.iam.gserviceaccount.com',
      'client_id' => '100459812085611549381',
      'auth_uri' => 'https://accounts.google.com/o/oauth2/auth',
      'token_uri' => 'https://accounts.google.com/o/oauth2/token',
      'auth_provider_x509_cert_url' => 'https://www.googleapis.com/oauth2/v1/certs',
      'client_x509_cert_url' => 'https://www.googleapis.com/robot/v1/metadata/x509/lc-docs-service%40lc-docs-development.iam.gserviceaccount.com'
    }.freeze

    # Use the generated client_secret.json file to authenticate the Google Drive service object.
    def authorize_service(service)
      create_client_secret_file
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
    def create_client_secret_file
      File.exist?(KEY_FILE.to_s) && File.delete(KEY_FILE.to_s)
      File.open(KEY_FILE.to_s, 'w') do |f|
        f.write(CLIENT_SECRET.to_json.gsub('\\\\', '\\'))
      end
    end
  end
end
