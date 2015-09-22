#
# Copyright 2015 Kazantzis Lazaros
#

class CreateRights < ActiveRecord::Migration
  def change
    create_table :rights do |t|
      t.string :label, {limit: 20, null: false}
      t.string :description, {limit: 50, null: false}
    end
  end
end
