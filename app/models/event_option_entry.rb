class EventOptionEntry < ApplicationRecord
  enum feeling: { None: 0, OK: 1, Neither: 2, NG: 3 }

  belongs_to :event_option
  belongs_to :event_entry
end
