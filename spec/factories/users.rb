FactoryBot.define do
  factory :user, class: User do
    id { 1 }
    name { 'Ichiro Example' }
    email { 'ichiro@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { 'true' }
    activated { 'true' }
    activated_at { Time.zone.now }
    current_team_id { 1 }
  end

  factory :other_user, class: User do
    id { 2 }
    name { 'Jiro Example' }
    email { 'Jiro@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    activated { 'true' }
    activated_at { Time.zone.now }
  end

  factory :users, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    activated { 'true' }
    activated_at { Time.zone.now }
  end
end
