class AccessController < ApplicationController
    before_action :authenticate_user, only: [:index, :destroy]
    
    def index
        #user_display = cookies.signed[:user_id]
    end
   
   def destroy
        cookies.delete(:user_id)
        @current_user = nil
        redirect_to root_url
   end
    
end