FactoryBot.define do
  factory :member_request1, class: MemberRequest do
    team
    user
  end

  factory :member_request2, class: MemberRequest do
    team
    user
  end

  factory :member_requests, class: MemberRequest do
    team_id { 1 }
    sequence(:user_id) { |n| n + 1 }
  end
end
