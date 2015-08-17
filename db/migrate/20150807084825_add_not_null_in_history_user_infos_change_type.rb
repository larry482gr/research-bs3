class AddNotNullInHistoryUserInfosChangeType < ActiveRecord::Migration
  def change
    change_column :history_user_infos, :change_type, :string, limit: 50, null: false
  end
end
