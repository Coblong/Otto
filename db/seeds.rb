# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(name: "Cobbers", email: "paul.cobley@gmail.com", password: "password", password_confirmation: "password", show_left_nav: true)

Status.create(description: "New", colour: "FFFFFF", user_id: user.id)
Status.create(description: "Hot", colour: "FFA399", user_id: user.id)
Status.create(description: "Warm", colour: "FFEEA8", user_id: user.id)
Status.create(description: "Cold", colour: "C7EAFF", user_id: user.id)    
