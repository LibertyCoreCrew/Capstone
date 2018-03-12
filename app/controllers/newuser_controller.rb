class NewuserController < ApplicationController
    
    def new
        @user = User.new
    end
    
    def create          
        @user = User.new(user_params)
        if @user.save
            cookies.signed[:user_id] = @user.name  
            redirect_to root_url
        else
            render :new

        end
    end


    
    private
    def user_params
        params.require(:user).permit(:name, :password)
    end

end