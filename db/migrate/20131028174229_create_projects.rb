#
# Copyright 2015 Kazantzis Lazaros
#

class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, {limit: 100, null: false}
      t.text :description, {limit: 5000, default: nil}
      t.boolean :is_private, {null: false, default: false}

      t.timestamps null: false
    end
  end
end
