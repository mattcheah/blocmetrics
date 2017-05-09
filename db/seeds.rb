# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    User.create({email: "matt.cheah@gmail.com", password: "password"})

5.times do 
    name = Faker::App.name
    RegisteredApplication.create({name: name, url: "#{name}.com", user_id: 1})
end

eventTypes = ["Pageview", "Contact Form Submission", "Ad Click", "Click to Call - Mobile", "Product Purchase"]

100.times do 
    app = RegisteredApplication.find(rand(5)+1)
    app.events.create({name: eventTypes[rand(5)]})
end