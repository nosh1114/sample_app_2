# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "hogehoge",
             password_confirmation: "hogehoge",
             admin: true
             )

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Movies::HarryPotter.character
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
