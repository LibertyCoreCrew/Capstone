class Project < ApplicationRecord
    has_many :tracts
    has_many :keydates
    has_many :google_files
    
    validates :name, numericality: { only_integer: true, :greater_than_or_equal_to => 0 }, :presence => true
    
    rails_admin do
      configure :name do
        label 'OPW #'
      end
    end
    
end
