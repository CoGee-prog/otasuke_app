# メインのサンプルユーザーを1人作成する
User.create!(name:  "KK",
            email: "bb.sca.ksk1@gmail.com",
            password:              "koshien",
            password_confirmation: "koshien",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)
            

# 追加のユーザーをまとめて生成する
99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@example.com"
password = "password"
User.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end
