class CreateHistoryReports < ActiveRecord::Migration
  def change
    create_table :history_reports, :id => false do |t|
      t.references :user
      t.references :project
      t.integer :reported_user, {null: false}
      t.datetime :invitation_sent_at
      t.timestamp :created_at
    end
    execute 'ALTER TABLE history_reports ADD PRIMARY KEY (user_id,project_id,created_at);';
  end
end
