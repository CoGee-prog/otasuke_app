FactoryBot.define do
  factory :event_entry, class: EventEntry do
    event_id { 1 }
    user_id { 1 }
  end

  factory :other_user_event_entry, class: EventEntry do
    event { 1 }
    user { 2 }
  end

  factory :other_event_event_entry, class: EventEntry do
    event { 2 }
    user { 1 }
  end
end
