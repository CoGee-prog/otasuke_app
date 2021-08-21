FactoryBot.define do
  factory :team_member1, class: TeamMember do
    team
    user
  end

  factory :team_member2, class: TeamMember do
    team
    user
  end

  factory :team_member3, class: TeamMember do
    team
    user
  end

  factory :team_members, class: TeamMember do
    team_id { 1 }
    sequence(:user_id) { |n| n + 1 }
  end
end
