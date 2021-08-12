class CreateEventOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :event_options do |t|
      t.references :event, foreign_key: true, null: false

      t.timestamps
    end
  end
end
