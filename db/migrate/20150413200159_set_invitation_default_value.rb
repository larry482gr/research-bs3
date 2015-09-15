#
# Copyright 2015 Kazantzis Lazaros
#

class SetInvitationDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :invitations, :status, 'pending'
  end
end
