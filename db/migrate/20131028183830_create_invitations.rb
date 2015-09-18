#
# Copyright 2015 Kazantzis Lazaros
#

class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations, :id => false do |t|
      t.references :user, {index: true, null: false}
      t.integer :from_user, {null: false}
      t.references :project, {index: true, null: false}
      t.references :project_profile, {null: false, default: 2}
      t.string :status, {limit: 10, null: false}
      t.string :reason, {limit: 255, default: nil}

      t.timestamps null: false
    end
    execute 'ALTER TABLE invitations ADD PRIMARY KEY (user_id, from_user, project_id);'
  end
end
