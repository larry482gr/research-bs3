#
# Copyright 2015 Kazantzis Lazaros
#

class ChangeInvitationsUserIdToEmail < ActiveRecord::Migration
  def change
    change_table :invitations do |t|
      t.remove_references(:user)
      t.string :email, { limit: 50, null: false }
    end
  end
end