FactoryBot.define do
  factory :event do
    team_id { 1 }
    day { "2021-08-03" }
    ground { "MyString" }
    opponent_team_name { "MyString" }
    tournament_name { "MyString" }
    other { "MyString" }
  end
end
