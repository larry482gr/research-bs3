#
# Copyright 2015 Kazantzis Lazaros
#

class RemoveUserEmailFromHistoryUserInfos < ActiveRecord::Migration
  def change
    change_table :history_user_infos do |t|
      t.remove :user_email
    end
  end
end
