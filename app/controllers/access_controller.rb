class AccessController < ApplicationController
   before_action :authenticate_user
    
    def index
        #user_display = cookies.signed[:user_id]
    end
   
   def destroy
        cookies.delete(:user_id)
        redirect_to root_url
   end
    
end