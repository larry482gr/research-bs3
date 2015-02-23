class CreateJoinTableProfileRight < ActiveRecord::Migration
  def change
    create_join_table :profiles, :rights do |t|
      t.index [:profile_id, :right_id]
      t.index [:right_id, :profile_id]
    end
  end
end
