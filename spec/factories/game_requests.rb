FactoryBot.define do
  factory :game_request do
    requesting_team_id { 1 }
    requested_team_id { 2 }
    contact_address { '000-0000-0000' }
    comment { 'よろしくお願いします！' }
  end
end
