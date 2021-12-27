class CreateEventComments < ActiveRecord::Migration[6.1]
  def change
    create_table :event_comments do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
			t.string :comment,  null: false, limit: 50

      t.timestamps
    end
  end
end
