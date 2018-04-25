class Project < ApplicationRecord
    has_many :tracts
    has_many :keydates
    has_many :google_files
end
