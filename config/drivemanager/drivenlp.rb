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
            
            # Enter file if it's not currently in the database, or if the file was modified after the file was entered
            if !GoogleFile.exists?( google_id: file.id ) or GoogleFile.where( google_id: file.id ).pluck( :last_change ) < file.modified_time
              if proj_num_found or tract_num_found
                @f = GoogleFile.new
                @f.google_id = file.id
                @f.last_change = file.modified_time
                @f.save

                if proj_num_found
                  if Project.exists?( name: proj_num )
                    @proj = Project.where( name: proj_num ).take
                    puts @proj.name
                    @proj.google_files << @f
                  end
                end

                if tract_num_found
                  if Tract.exists?( name: tract_num )
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
