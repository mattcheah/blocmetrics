class RegisteredApplication < ActiveRecord::Base
  
  #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  belongs_to :user
  has_many :events
end
