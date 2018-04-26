class Tract < ApplicationRecord
    belongs_to :project, foreign_key: 'project_id', optional: true
    belongs_to :user, foreign_key: 'user_id', optional: true
    has_many :keydates
    has_many :google_files
    
    validates :name, :parcel_address, :owner_name, :payment_amount, :presence => true
    
    validates :owner_phone, allow_blank: true, format: { with: /\d{3}-\d{3}-\d{4}/ }
    validates :owner_email, allow_blank: true, :format => /@/
    validates :name, numericality: { only_integer: true, :greater_than_or_equal_to => 0 }
    validates :payment_amount, numericality: { :greater_than_or_equal_to => 0 }
    
    rails_admin do
      configure :name do
        label 'Tract No.'
      end
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
