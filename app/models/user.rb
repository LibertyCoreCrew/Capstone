class User < ApplicationRecord
  has_many :tracts
  
  
  rails_admin do
    configure :tracts do
        label 'Tracts that this agent is working'
    end
  end
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
