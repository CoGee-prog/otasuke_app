class EventOptionEntry < ApplicationRecord
  enum feeling: { None: 0, OK: 1, Neither: 2, NG: 3 }

  validate_enum_attributes :feeling
  validates :event_option_id, presence: true, uniqueness: { scope: :event_entry_id }
  validates :event_entry, presence: true

  belongs_to :event_option
  belongs_to :event_entry
end
