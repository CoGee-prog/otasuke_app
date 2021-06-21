FactoryBot.define do
  factory :user do
    name { 'Ichiro Example' }
    email { 'ichiro@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
