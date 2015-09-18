#
# Copyright 2015 Kazantzis Lazaros
#

class CreateHistoryProjects < ActiveRecord::Migration
  def change
    create_table :history_projects, :id => false do |t|
      t.references :user
      t.references :project
      t.string :from_value, {limit: 20, null: false}
      t.string :to_value, {limit: 20, null: false}
      t.string :change_type, {limit: 20, null: false}
      t.timestamp :created_at, null: false
    end
    execute 'ALTER TABLE history_projects ADD PRIMARY KEY (user_id,project_id,created_at);';
  end
end