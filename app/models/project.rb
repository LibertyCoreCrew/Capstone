class Project < ApplicationRecord
    has_many :tracts
    has_many :keydates
end
