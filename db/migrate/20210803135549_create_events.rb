class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :team, foreign_key: true, null: false
      t.date :day, index: true, null: false
      t.time :time, index: true, null: false
      t.string :ground
      t.string :opponent_team_name
      t.string :tournament_name
      t.string :other

      t.timestamps
    end
  end
end
