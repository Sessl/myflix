# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

suchitra = User.create(username: "Suchitra Edussuriya-Essl", password: "password", email: "suchitra@example.com")

monk = Video.create(title: "Monk", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", description: "Detective Series")
family = Video.create(title: "Family Guy", small_cover_url: "/tmp/family_guy.jpg", description: "Family with a talking Dog")
future = Video.create(title: "Futurama", small_cover_url: "/tmp/futurama.jpg", description: "Animation abou the future!? Oh I don't know")
south = Video.create(title: "South Park", small_cover_url: "/tmp/south_park.jpg", description: "Life in Small Town America")
category1 = Category.create(name: "Comedy")
category2 = Category.create(name: "Animation")
category3 = Category.create(name: "Sci-Fi")
category4 = Category.create(name: "Drama")

monk.categories << category4
monk.categories << category1
family.categories << category1
family.categories << category2
future.categories << category1
future.categories << category2
future.categories << category3
south.categories << category1
south.categories << category2


Review.create(user: suchitra, video: monk, rating: 3, content: "This is ok. I don't care for it that much.")
Review.create(user: suchitra, video: monk, rating: 1, content: "Don't like it!")