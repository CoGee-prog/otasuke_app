class AddEventOrderToTeamMember < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :event_order, :integer, default: nil
  end
end
