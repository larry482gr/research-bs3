#
# Copyright 2015 Kazantzis Lazaros
#

class CreateProjectProfiles < ActiveRecord::Migration
  def change
    create_table :project_profiles do |t|
      t.string :label, {limit: 20, null: false}
      t.string :description, {limit: 30, null: false}
    end
  end
end
