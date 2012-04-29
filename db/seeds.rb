# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

questions = [
  {text: "What do you eat for breakfast?"},
  {text: "What time do you usually eat dinner?"},
  {text: "What are your favourite spices?"},
  {text: "What’s the traditional food in your country?"},
  {text: "What is your favourite meal?"},
  {text: "Do you know any typical austrian dishes?"},
  {text: "Do you have a food tradition in your family?"},
  {text: "What do you usually eat at New Years Eve?"},
  {text: "What’s the typical drink of your country?"},
  {text: "What's your favourite birthday dessert?"},
]

Question.delete_all
questions.each do |q|
  Question.find_or_create_by q
end