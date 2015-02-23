class CreateHistoryReports < ActiveRecord::Migration
  def change
    create_table :history_reports, :id => false do |t|
      t.references :user, {index: true, primary_key: true}
      t.references :project, {index: true, primary_key: true}
      t.integer :reported_user, {null: false}
      t.datetime :invitation_sent_at, {index: true, primary_key: true}
      t.datetime :created_at
    end
  end
end
