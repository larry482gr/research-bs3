#
# Copyright 2015 Kazantzis Lazaros
#

class CreateCitations < ActiveRecord::Migration
  def change
    create_table :citations, :id => false do |t|
      t.string :citation_id, {limit: 30}
      t.text :citation_mla
      t.text :citation_apa
      t.text :citation_chicago
    end
    execute 'ALTER TABLE citations ADD PRIMARY KEY (citation_id);'
  end
end
