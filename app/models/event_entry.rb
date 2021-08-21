class EventEntry < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_one :event_option_entry, dependent: :destroy

  validates :user_id, presence: true, uniqueness: { scope: :event_id }
  validates :event_id, presence: true
  accepts_nested_attributes_for :event_option_entry

  after_create :create_option_entry

  private

  def create_option_entry
    create_event_option_entry(event_option_id: event.event_option.id)
  end
end
