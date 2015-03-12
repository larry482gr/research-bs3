class Profile < ActiveRecord::Base
  validates_uniqueness_of :label
  has_and_belongs_to_many :rights
  has_many :users, through: :user_info

  OWNER = 'owner'
  ADMIN = 'admin'
end
