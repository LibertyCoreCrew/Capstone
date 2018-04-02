class PagesController < ApplicationController
	include DriveManager
  def login
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
