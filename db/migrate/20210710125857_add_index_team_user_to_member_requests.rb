class AddIndexTeamUserToMemberRequests < ActiveRecord::Migration[6.1]
  def change
    add_index :member_requests, [:team_id, :user_id], unique: true
  end
end
