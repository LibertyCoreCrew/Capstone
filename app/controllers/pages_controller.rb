class PagesController < ApplicationController
	include DriveManager
	before_action :authenticate_user!, except: [:login]
  def login
      redirect_to new_user_session_path
  end

  def index
  end

  def admin
  end
  
  def dashboard
  end
  
  def documents
  @user_id = ENV["LC_PRIVATE_KEY_ID"]
  end
end
