class ChangeDatatypeDayTimeOfEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :day_time, :datetime
  end
end
