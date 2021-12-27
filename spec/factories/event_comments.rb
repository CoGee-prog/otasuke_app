FactoryBot.define do
  factory :event_comment do
    comment { "MyString" }
    user { nil }
    team { nil }
  end
end
