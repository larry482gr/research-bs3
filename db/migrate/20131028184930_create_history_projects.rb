class CreateHistoryProjects < ActiveRecord::Migration
  def change
    create_table :history_projects, :id => false do |t|
      t.references :user, {index: true, primary_key: true}
      t.references :project, {index: true, primary_key: true}
      t.string :from_value, {limit: 20, null: false}
      t.string :to_value, {limit: 20, null: false}
      t.string :change_type, {limit: 20, null: false}
      t.datetime :datetime, primary_key: true
    end
  end
end
