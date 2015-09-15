#
# Copyright 2015 Kazantzis Lazaros
#

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, {limit: 20, null: false, unique: true}
      t.string :password, {limit: 50, null: false}
      t.string :email, {limit: 50, null: false, unique: true}
      t.references :profile, {index: true, null: false}

      t.timestamps null: false
    end
  end
end
