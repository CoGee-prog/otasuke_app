class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :image
      t.integer :admin_user_id
      t.string :level
      t.string :area
      t.string :activity_day
      t.string :activity_frequency

      t.timestamps
    end
    add_index :teams, :name
    add_index :teams, :level
    add_index :teams, :area
    add_index :teams, :activity_day
  end
end
