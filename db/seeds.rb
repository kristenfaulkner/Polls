# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create!([
  { user_name: "user_one" },
  { user_name: "user_two" },
  { user_name: "user_three" }
])
  
polls = Poll.create!([
  { title: "poll_one", author_id: 1 }, 
  { title: "poll_two", author_id: 2 }
])
  
questions = Question.create!([
  { question: "question_one", poll_id: 1 }, 
  { question: "question_two", poll_id: 2 },
  { question: "question_three", poll_id: 2 }
])
  
answer_choices = AnswerChoice.create!([
  { question_id: 1, answer: "answer_one" },
  { question_id: 2, answer: "answer_two" }, 
  { question_id: 3, answer: "answer_three" }
])

responses = Response.create!([
  { user_id: 2, answer_id: 1 },
  { user_id: 3, answer_id: 1 },
  { user_id: 3, answer_id: 3 }
])