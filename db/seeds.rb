# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
(1..2).each do |i|
  User.create!(
    access_token: "token#{i}",
    api_rate_limit: i * 10
  )

  RequestCounter.create!(
    access_token: "token#{i}",
    count: 0,
    start_at: Time.zone.now
  )
end
