class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.references :project, index: true
      t.references :user, index: true
      t.string :filename, {null: false}
      t.string :extension, {limit: 10, null: false}
      t.string :filepath, {null: false}
      t.boolean :is_basic
      t.boolean :is_old

      t.timestamps
    end
  end
end