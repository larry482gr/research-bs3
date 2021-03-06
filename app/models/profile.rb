#
# Copyright 2015 Kazantzis Lazaros
#

class Profile < ActiveRecord::Base
  validates_uniqueness_of :label
  has_and_belongs_to_many :rights
  has_many :users

  OWNER = 'owner'
  ADMIN = 'admin'
  USER = 'user'
end
