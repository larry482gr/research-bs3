class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user, index: true
      t.integer :from_user, {null: false}
      t.references :project, index: true
      t.references :project_profile, index: true
      t.string :status, {limit: 10, null: false}
      t.string :reason, {limit: 20, default: nil}

      t.timestamps
    end
  end
end
