class CreateJoinTableUserProject < ActiveRecord::Migration
  def change
    create_join_table :users, :projects do |t|
      t.index [:user_id, :project_id]
      t.index [:project_id, :user_id]
      t.references :project_profile
    end
  end
end
