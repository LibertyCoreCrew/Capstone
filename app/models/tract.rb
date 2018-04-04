class Tract < ApplicationRecord
    belongs_to :project, foreign_key: 'project_id', optional: true
    belongs_to :user, foreign_key: 'user_id', optional: true
    has_many :keydates
    
    rails_admin do
      configure :user do
        label 'Agent assigned to this tract'
      end
      configure :project do
        label 'Project this tract is a part of'
      end
      configure :owner_name do
        label 'Owner name(s)'
      end
    end
  
end
