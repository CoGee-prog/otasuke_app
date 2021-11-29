class AddDisplayNameToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :display_name, :string, limit: 50, default: ''
  end
end
