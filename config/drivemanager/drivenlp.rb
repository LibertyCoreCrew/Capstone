module DriveManager
  # Class for performing natural language processing
  class DriveNLP
    def self.process( file, contents )
        
        unless contents.empty?
            c = contents.split()
            p, t = c.index( "OPW" ), c.index( "Tract" )
            proj_num, tract_num = "", ""
            proj_num_found, tract_num_found = false, false
            
            
            if !p.nil? or !t.nil?
                puts "File name: " + file.name
            end
            
            # Finds the OPW Project number, also avoids files that don't contain identifying information
            unless p.nil?
              for i in p..c.length-1
                  if c[i] !~ /\D/       # This finds the next character block that is all-numeric
                      proj_num = c[i]
                      proj_num_found = true
                      puts "Project: OPW " + proj_num
                      break
                  end
              end
            end
            
            # Finds the Tract number, also avoids files that don't contain identifying information
            unless t.nil?
              for i in t..c.length-1
                  if c[i] !~ /\D/       # This finds the next character block that is all-numeric
                      tract_num = c[i]
                      tract_num_found = true
                      puts "Tract: No. " + tract_num
                      break
                  end
              end
            end
            
            file_exists, file_has_been_modified = false, false
            
            # Determines if the file exists within the database, and if it has been modified since the last time it was pulled
            if GoogleFile.exists?( google_id: file.id )
              file_exists = true
              if GoogleFile.where( google_id: file.id ).take.last_change < file.modified_time
                file_has_been_modified = true
              end
            end
            
            # Only enter the file into the DB if the file doesn't exist, or isn't up to date
            if !file_exists or file_has_been_modified
              if proj_num_found or tract_num_found
                
                if !file_exists         # Create a new entry for the file
                  @f = GoogleFile.new
                  @f.google_id = file.id
                  @f.last_change = file.modified_time
                  @f.save
                else  # Update the modified time
                  @f = GoogleFile.find_by( google_id: file.id )
                  @f.last_change = file.modified_time
                  @f.save
                end
                
                # Relate the file to a project, if the project information was found
                if proj_num_found
                  if Project.exists?( name: proj_num ) and !file_exists
                    @proj = Project.where( name: proj_num ).take
                    @proj.google_files << @f
                  end
                end
                
                # Relate the file to a tract, if the tract information was found
                if tract_num_found
                  if Tract.exists?( name: tract_num ) and !file_exists
                    @trac = Tract.where( name: tract_num ).take
                    @trac.google_files << @f
                  end
                end
              end
            end
            
        end
      
    end
  end
end
