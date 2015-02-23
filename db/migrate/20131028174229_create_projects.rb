class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, {limit: 100, null: false}
      t.text :description, {limit: 5000, default: nil}
      t.boolean :is_private

      t.timestamps
    end
  end
end
