#
# Copyright 2015 Kazantzis Lazaros
#

class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :label, {limit: 20, null: false}
      t.string :description, {limit: 30, null: false}
    end
  end
end
