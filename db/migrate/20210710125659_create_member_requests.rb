class CreateMemberRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :member_requests do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
