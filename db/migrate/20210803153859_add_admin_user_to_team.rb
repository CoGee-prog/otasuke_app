class AddAdminUserToTeam < ActiveRecord::Migration[6.1]
  def change
    add_reference :teams, :admin_user, foreign_key: {to_table: :users}, null: false
  end
end
