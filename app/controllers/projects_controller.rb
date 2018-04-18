class ProjectsController < ApplicationController
    
    def show
        @project = Project.find(params[:id])
        @project_tracts = @project.tracts
    end

end