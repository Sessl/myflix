Fabricator(:user) do
  username { Faker::Name.name}
  email { Faker::Internet.email}
  password { Faker::Internet.password}
end