#
# Copyright 2015 Kazantzis Lazaros
#

class AddIdToInvitations < ActiveRecord::Migration
  def change
    execute "ALTER TABLE invitations DROP PRIMARY KEY"
    add_column :invitations, :id, :primary_key
  end
end
