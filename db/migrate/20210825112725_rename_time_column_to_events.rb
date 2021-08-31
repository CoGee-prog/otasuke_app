class RenameTimeColumnToEvents < ActiveRecord::Migration[6.1]
  def change
    rename_column :events, :time, :day_time
  end
end
