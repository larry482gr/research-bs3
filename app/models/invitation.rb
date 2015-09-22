#
# Copyright 2015 Kazantzis Lazaros
#

class Invitation < ActiveRecord::Base
  belongs_to :user, :foreign_key => :email
  belongs_to :project
  belongs_to :project_profile
end