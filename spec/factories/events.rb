FactoryBot.define do
  factory :event, class: Event do
    id { 1 }
    team_id { 1 }
    day { '2021-08-03' }
    time { '13:00' }
    ground { '札幌ドーム' }
    opponent_team_name { 'イーグルス' }
    tournament_name { 'パ・リーグトーナメント' }
    other { '三塁側' }
  end

  factory :other_team_event, class: Event do
    id { 2 }
    team_id { 2 }
    day { '2021-08-05' }
    time { '10:00' }
    ground { '東京ドーム' }
    opponent_team_name { 'ジャイアンツ' }
    tournament_name { '交流戦' }
    other { '三塁側' }
  end
end
