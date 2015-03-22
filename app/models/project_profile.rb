class ProjectProfile < ActiveRecord::Base
  validates_uniqueness_of :label
  has_many :users
  has_many :projects

  OWNER = 'owner'
  COLLABORATOR = 'collaborator'
end
