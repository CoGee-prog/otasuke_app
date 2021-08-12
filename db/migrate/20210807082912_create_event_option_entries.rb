class CreateEventOptionEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :event_option_entries do |t|
      t.integer :feeling, default: 0, null: false
      t.references :event_option, foreign_key: true, null: false
      t.references :event_entry, foreign_key: true, null: false

      t.timestamps
    end
    add_index :event_option_entries, [:event_option_id, :event_entry_id], unique: true
  end
end
