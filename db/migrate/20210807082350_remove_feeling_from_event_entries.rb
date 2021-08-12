class RemoveFeelingFromEventEntries < ActiveRecord::Migration[6.1]
  def change
    remove_column :event_entries, :feeling, :integer
  end
end
