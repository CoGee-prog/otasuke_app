class CreateEventEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :event_entries do |t|
      t.references :event, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :feeling, default: 0

      t.timestamps
    end
    add_index :event_entries, [:event_id, :user_id], unique: true
  end
end
