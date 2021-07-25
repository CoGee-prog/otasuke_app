class AddOtherToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :other, :text
  end
end
