class AddChangeTypeToHistoryProjectsPkey < ActiveRecord::Migration
  def change
    execute 'ALTER TABLE history_projects DROP PRIMARY KEY'
    execute 'ALTER TABLE history_projects ADD PRIMARY KEY (user_id,project_id,change_type,created_at)'
  end
end
