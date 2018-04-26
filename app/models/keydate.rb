class Keydate < ApplicationRecord
    belongs_to :project, foreign_key: 'project_id', optional: true
    belongs_to :tract, foreign_key: 'tract_id', optional: true
    
    validates :name, :date, :presence => true
    
    rails_admin do
      configure :project do
        label 'Project that this keydate is associated with'
      end
      configure :tract do
        label 'Tract that this keydate is associated with'
      end
    end

end