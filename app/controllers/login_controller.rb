class LoginController < ApplicationController
    
    def index
        #redirect_to access_url if [:authenticate_user]
    end
    
    def create
        user = User.find_by("name = ?", user_params[:name])
        
        if user.present? && user.authenticate(user_params[:password])
            cookies.permanent.signed[:user_id] = user.name
            redirect_to access_url
        else
            flash.now[:error] = "Invalid name/pw combination"
            render :index
        end
    end
=begin    
        user = User.authenticate(params[:session][:email], params[:session][:password])
        
        if user.nil?
            flash.now[:error] = "Invalid name/pw combination"
            render :new
        else
            sign_in user
            redirect_to user
        end
    end
=end
    
    def user_params
        params.require(:user).permit(:name, :password)
    end
end