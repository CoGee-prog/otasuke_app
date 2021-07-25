class ChangeDataActivityDayToTeams < ActiveRecord::Migration[6.1]
  def change
    change_column :teams, :activity_day, :integer
  end
end
