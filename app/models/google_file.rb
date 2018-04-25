class GoogleFile < ApplicationRecord
    belongs_to :tract, foreign_key: 'project_id', optional: true
    belongs_to :project, foreign_key: 'tract_id', optional: true
end
