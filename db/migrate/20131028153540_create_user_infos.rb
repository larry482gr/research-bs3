class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos, :id => false do |t|
      t.references :user, {null: false}
      t.string :first_name, {limit: 20, default: nil}
      t.string :last_name, {limit: 30, default: nil}
      t.references :language, {index: true, null: false, default: 1}
      t.boolean :activated, {null: false, default: 0}
      t.boolean :blacklisted, {null: false, default: 0}
      t.integer :reports, {limit: 1, null: false, default: 0}
      t.string :token, {limit: 255, null: true}
    end
    execute "ALTER TABLE user_infos ADD PRIMARY KEY (user_id);"
  end
end
