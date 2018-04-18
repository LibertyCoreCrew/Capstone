require 'google/apis/drive_v2'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'manager'
require 'fileutils'

# Controller for all pages
class PagesController < ApplicationController

  include DriveManager
  # puts Dir.pwd + '/client_secret.json'
  # puts CLIENT_SECRETS_PATH

  before_action :authenticate_user!, except: [:login]

  def login
    redirect_to new_user_session_path
  end

  def index

  end

  def admin

  end

  def dashboard
    # Loads the current user into the @user variable
    @user = current_user                # Assign the agent whose tracts and projects will be displayed

    if @user.admin?
      @user_tracts = Tract.all
      @user_projects = Project.all.pluck( :id )
      @display_name = ''
    else
      @user_tracts = @user.tracts         # The array whose contents are the agent's assigned tracts
      # The collection of projects the user works in, through their assigned tracts
      @user_projects = @user.tracts.all.select( :project_id ).distinct.pluck( :project_id )
      @display_name = 'Your '
    end
  end

  def documents

    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
     
      FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

      client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(
        client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(
          base_url: OOB_URI)
        puts "Open the following URL in the browser and enter the " +
             "resulting code after authorization"
        puts url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI)
      end
      credentials
    end
    # Initialize the API
    #service = Google::Apis::DriveV2::DriveService.new
  	Manager.new.initialize
	  @result = Manager.service.list_files(page_size: 10, fields: 'nextPageToken, files(id, name)')
    #service.client_options.application_name = APPLICATION_NAME
    #service.authorization = authorize
    #@service = service.list_files()
    
  end
  
end

# r = b.documents
