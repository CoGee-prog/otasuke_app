class RemoveActivityDayFromTeams < ActiveRecord::Migration[6.1]
  def change
    remove_index :teams, name: "index_teams_on_activity_day"
    remove_column :teams, :activity_day
  end
end
