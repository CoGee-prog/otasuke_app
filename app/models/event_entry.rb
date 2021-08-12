class EventEntry < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_one :event_option_entry, dependent: :destroy

  accepts_nested_attributes_for :event_option_entry

  after_create :create_option_entry

  private

  def create_option_entry
    create_event_option_entry(event_option_id: self.event.event_option.id)
  end
  
end
