class RemoveImageFromTeams < ActiveRecord::Migration[6.1]
  def change
    remove_column :teams, :image, :string
  end
end
