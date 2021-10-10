FactoryBot.define do
  factory :user, class: 'User' do
    id { 1 }
    name { 'イチロー' }
    email { 'ichiro@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { 'true' }
    activated { 'true' }
    activated_at { Time.zone.now }
    current_team_id { 1 }
  end

  factory :other_user, class: 'User' do
    id { 2 }
    name { 'ジロー' }
    email { 'jiro@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    activated { 'true' }
    activated_at { Time.zone.now }
    current_team_id { 2 }
  end

  factory :not_admin_user, class: 'User' do
    id { 3 }
    name { 'サブロー' }
    email { 'saburo@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    activated { 'true' }
    activated_at { Time.zone.now }
    current_team_id { 1 }
  end

  factory :unrelated_user, class: 'User' do
    id { 4 }
    name { 'シロー' }
    email { 'shiro@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    activated { 'true' }
    activated_at { Time.zone.now }
    current_team_id { 2 }
  end

  factory :users, class: 'User' do
    sequence(:id) { |n| n + 1 }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    activated { 'true' }
    activated_at { Time.zone.now }
  end
end
