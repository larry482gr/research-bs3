#
# Copyright 2015 Kazantzis Lazaros
#

class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.references :project, index: true
      t.references :user, index: true
      t.string :filename, {null: false}
      t.string :extension, {limit: 10, null: false}
      t.string :filepath, {null: false}
      t.boolean :is_basic, {null: false, default: false}
      t.integer :reference, {null: false, default: 0}

      t.timestamps null: false
    end
  end
end