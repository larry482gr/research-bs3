class Profile < ActiveRecord::Base
  has_and_belongs_to_many :rights
  has_many :users, through: :user_info
end
