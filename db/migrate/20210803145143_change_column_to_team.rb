class ChangeColumnToTeam < ActiveRecord::Migration[6.1]
  def change
    change_column_null :teams, :name, false
    change_column_null :teams, :level, false
    change_column_null :teams, :prefecture_id, false
    change_column_null :teams, :activity_monday, false
    change_column_null :teams, :activity_tuesday, false
    change_column_null :teams, :activity_wednesday, false
    change_column_null :teams, :activity_thursday, false
    change_column_null :teams, :activity_friday, false
    change_column_null :teams, :activity_saturday, false
    change_column_null :teams, :activity_sunday, false
    change_column_null :teams, :admin_user_id, false
    add_reference :teams, :admin_user_id, null: false, foreign_key: {to_table: :users}
  end
end
