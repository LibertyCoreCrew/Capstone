class TractsController < ApplicationController
    
    def show
        @tract = Tract.find(params[:id])
        
        if( !current_user.admin? and current_user.id != @tract.user_id )
            redirect_to main_app.root_path
        end
    end

end