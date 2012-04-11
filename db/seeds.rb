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
  {text: "What would you consider as traditional food of your country?"},
  {text: "What is your favourite meal?"},
  {text: "Do you prefer cooking at home or eating out?"},
  {text: "What traditional Austrian foods can you think of?"},
  {text: "How do you eat your food? (cutlery, chopsticks, hands, ...)"},
  {text: "Which specific dinner traditions are there in your family?"},
  {text: "Are there special grandma's secrets you want to tell us? Which special grandma's secret do you want to tell us?"},
  {text: "What do you usually eat at Christmas / New Years Eve?"},
  {text: "What would you consider as traditional dessert of your country?"},
  {text: "What's your attitude towards alcohol?"},
  {text: "What beverage is characteristic for your country/region?"},
  {text: "Do you grow your own vegetables/herbs?"},
  {text: "What do you drink for special occasions?"},
  {text: "What do you eat on new years eve?"},
  {text: "What's your favourite birthday dessert?"},
  {text: "What's your favourite snack?"},
  {text: "What's your favourite self-made recipe?"},
]

Question.delete_all
questions.each do |q|
  Question.find_or_create_by q
end