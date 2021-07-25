class AddIndexTeamUserToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_index :team_members, [:team_id, :user_id], unique: true
  end
  

end
