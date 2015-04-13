class SetInvitationDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :invitations, :status, 'pending'
  end
end
