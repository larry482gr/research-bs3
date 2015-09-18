#
# Copyright 2015 Kazantzis Lazaros
#

class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.references :user, {index: true, null: false}
      t.string :first_name, {limit: 20, default: nil}
      t.string :last_name, {limit: 30, default: nil}
      t.references :language, {index: true, null: false, default: 1}
      t.boolean :activated, {null: false, default: false}
      t.boolean :blacklisted, {null: false, default: false}
      t.boolean :deleted, {null: false, default: false}
      t.integer :reports, {limit: 1, null: false, default: 0}
      t.string :token, {limit: 255, null: true}
    end
  end
end
