FactoryBot.define do
  factory :team, class: Team do
    id { 1 }
    name { 'ファイターズ' }
    admin_user_id { 1 }
    level { '全国大会上位レベル' }
    prefecture_id { 1 }
    activity_monday { 'false' }
    activity_tuesday { 'false' }
    activity_wednesday { 'false' }
    activity_thursday { 'false' }
    activity_friday { 'false' }
    activity_saturday { 'true' }
    activity_sunday { 'true' }
    activity_frequency { '週2回' }
  end

  factory :other_team1, class: Team do
    id { 2 }
    name { 'イーグルス' }
    admin_user_id { 2 }
    level { '全国大会上位レベル' }
    prefecture_id { 2 }
    activity_monday { 'false' }
    activity_tuesday { 'false' }
    activity_wednesday { 'false' }
    activity_thursday { 'false' }
    activity_friday { 'false' }
    activity_saturday { 'true' }
    activity_sunday { 'true' }
    activity_frequency { '週2回' }
  end

  factory :other_team2, class: Team do
    id { 3 }
    name { 'ジャイアンツ' }
    admin_user_id { 2 }
    level { '全国大会出場レベル' }
    prefecture_id { 3 }
    activity_monday { 'false' }
    activity_tuesday { 'false' }
    activity_wednesday { 'false' }
    activity_thursday { 'false' }
    activity_friday { 'false' }
    activity_saturday { 'true' }
    activity_sunday { 'true' }
    activity_frequency { '週2回' }
  end

  factory :other_team3, class: Team do
    id { 4 }
    name { 'ドラゴンズ' }
    admin_user_id { 2 }
    level { '都道府県大会上位レベル' }
    prefecture_id { 4 }
    activity_monday { 'false' }
    activity_tuesday { 'false' }
    activity_wednesday { 'false' }
    activity_thursday { 'false' }
    activity_friday { 'true' }
    activity_saturday { 'false' }
    activity_sunday { 'false' }
    activity_frequency { '週2回' }
  end

  factory :teams, class: Team do
    name { Faker::Name.name }
    admin_user_id { 1 }
    level { '試合経験はほぼない' }
    prefecture_id { 4 }
    activity_monday { 'false' }
    activity_tuesday { 'false' }
    activity_wednesday { 'false' }
    activity_thursday { 'true' }
    activity_friday { 'false' }
    activity_saturday { 'false' }
    activity_sunday { 'false' }
    activity_frequency { '週2回' }
  end
end
