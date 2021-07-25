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

  factory :other_team, class: Team do
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
end
