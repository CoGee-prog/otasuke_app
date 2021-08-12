class RemoveAdminUserIdFromTeam < ActiveRecord::Migration[6.1]
  def change
    remove_column :teams, :admin_user_id, :integer
    remove_column :teams, :admin_user_id_id, :references
  end
end
