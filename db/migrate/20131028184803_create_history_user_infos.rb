#
# Copyright 2015 Kazantzis Lazaros
#

class CreateHistoryUserInfos < ActiveRecord::Migration
  def change
    create_table :history_user_infos, :id => false do |t|
      t.references :user
      t.string :user_email, {limit: 50, null: false}
      t.string :admin, {limit: 20, null: false}
      t.string :from_value, {limit: 20, null: false}
      t.string :to_value, {limit: 20, null: false}
      t.string :change_type, {limit: 50}
      t.string :comment, {limit: 255, null: true, default: nil}
      t.timestamp :created_at, null: false
    end
    execute 'ALTER TABLE history_user_infos ADD PRIMARY KEY (user_id,change_type,created_at);';
  end
end
