class AccessController < ApplicationController
    before_action :authenticate_user
    
    def index
        @user = @current_user
    end
   
   def destroy
        cookies.delete(:user_id)
        @current_user = nil
        redirect_to root_url
   end

end