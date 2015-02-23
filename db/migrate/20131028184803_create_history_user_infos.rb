class CreateHistoryUserInfos < ActiveRecord::Migration
  def change
    create_table :history_user_infos, :id => false do |t|
      t.references :user, {index: true, primary_key: true}
      t.string :user_email, {limit: 50, null: false}
      t.string :admin, {limit: 20, null: false, primary_key: true}
      t.string :from_value, {limit: 20, null: false}
      t.string :to_value, {limit: 20, null: false}
      t.string :change_type, {limit: 20, null: false}
      t.datetime :datetime, primary_key: true
    end
  end
end
