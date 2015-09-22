#
# Copyright 2015 Kazantzis Lazaros
#

class CreateJoinTableProjectCitation < ActiveRecord::Migration
  def change
    create_join_table :projects, :citations do |t|
      t.string :citation_id, :limit => 30
      t.index [:project_id, :citation_id]
      t.index [:citation_id, :project_id]
      t.string :citation_type, :limit => 30
    end
    execute 'ALTER TABLE citations_projects ADD PRIMARY KEY (project_id, citation_id);'
  end
end
