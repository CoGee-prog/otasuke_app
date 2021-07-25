class AddWeeklyToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :activity_monday, :boolean
    add_column :teams, :activity_tuesday, :boolean
    add_column :teams, :activity_wednesday, :boolean
    add_column :teams, :activity_thursday, :boolean
    add_column :teams, :activity_friday, :boolean
    add_column :teams, :activity_saturday, :boolean
    add_column :teams, :activity_sunday, :boolean
  end
end
