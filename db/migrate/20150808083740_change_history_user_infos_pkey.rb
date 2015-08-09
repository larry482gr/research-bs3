class ChangeHistoryUserInfosPkey < ActiveRecord::Migration
  def change
    remove_column :history_user_infos, :user_email
    change_column :history_user_infos, :admin, :integer

    execute 'ALTER TABLE history_user_infos DROP PRIMARY KEY;'
    execute 'ALTER TABLE history_user_infos ADD PRIMARY KEY (user_id, created_at);'
  end
end
