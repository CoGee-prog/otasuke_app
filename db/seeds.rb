# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
            email: "example@example.com",
            password:              "hogehoge",
            password_confirmation: "hogehoge",
            admin: true)

# 追加のユーザーをまとめて生成する
99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@example.com"
password = "password"
User.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password)
end
