class NewuserController < ApplicationController


    
    def new
        @user = User.new
    end
    
    def create          
        @user = User.new(user_params)
        if @user.save
            puts "you suck"
            #cookies.sign[:user_id] = @user.name  
            redirect_to root_url
        else
            puts "you suck more"
            render :new

        end
    end


    
    private
    def user_params
        params.require(:user).permit(:name, :password)
    end

end