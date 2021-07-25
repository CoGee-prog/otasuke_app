FactoryBot.define do
  factory :team_member1, class: TeamMember do
    team
    user
  end
  factory :team_member2, class: TeamMember do
    team
    user
  end
end
