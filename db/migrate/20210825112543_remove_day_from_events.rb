class RemoveDayFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :day, :date
  end
end
