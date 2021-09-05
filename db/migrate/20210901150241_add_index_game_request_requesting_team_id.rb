class AddIndexGameRequestRequestingTeamId < ActiveRecord::Migration[6.1]
  def change
    add_index :game_requests, [:requesting_team_id, :requested_team_id], unique: true
  end
end
