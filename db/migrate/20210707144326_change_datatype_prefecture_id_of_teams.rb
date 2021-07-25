class ChangeDatatypePrefectureIdOfTeams < ActiveRecord::Migration[6.1]
  def change
    change_column :teams, :prefecture_id, :integer
  end
end
