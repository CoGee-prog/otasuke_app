class RenameAreaColumnToTeam < ActiveRecord::Migration[6.1]
  def change
    rename_column :teams, :area, :prefecture_id
  end
end
