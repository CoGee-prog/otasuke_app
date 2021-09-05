class CreateGameRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :game_requests do |t|
      t.bigint :requesting_team_id, index: true
      t.bigint :requested_team_id, index: true
      t.string :contact_address
      t.text :comment

      t.timestamps
    end
    add_foreign_key :game_requests, :teams, column: :requesting_team_id
    add_foreign_key :game_requests, :teams, column: :requested_team_id
  end
end
