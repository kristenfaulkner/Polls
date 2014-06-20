# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many(
    :authored_polls,
    class_name: "Poll",
    primary_key: :id,
    foreign_key: :author_id
  )
  
  has_many(
    :responses,
    class_name: "Response",
    primary_key: :id,
    foreign_key: :user_id
  )
  
  def completed_polls
    completed_polls = []
    unauthored_polls.includes(questions: [{ answer_choices: :responses }]).each do |poll|
      counter = 0
      poll.questions.each do |question|
        question.answer_choices.each do |answer_choice|
          answer_choice.responses.each do |response|
            if response.user_id == self.id
              counter += 1 
            end
          end
        end
      end
      completed_polls << poll if counter == poll.num_questions
    end
    completed_polls
  end
  
  def uncompleted_polls
    
  end
  
  def unauthored_polls
    Poll.where('polls.author_id != ?', self.id)
  end
end


# joined = Poll.joins(questions: [ { answer_choices: :responses } ])
#       .where("response.user_id = ?", self.id)
#
#       poll.count(questions) = poll.questions.count(responses).where ()
#
#
# Poll.joins(questions: [ :answer_choices ])
#   .joins("LEFT OUTER JOIN responses ON ...")
#   .where("response.user_id = ?", self.id)
#   .group("polls.id")
#   .select('COUNT(*) AS num_responses, COUNT(questions.id) AS num_questions,
#   (num_responses = num_questions) AS completed_poll?')

# There's at most one response per question.
# What if there's no responses for a question.
# Poll.joins({ questions: [ ... ]}
# .joins("LEFT OUTER JOIN responses ...")
# => Also want the group by that you already have.
# => We'll get every answer for a poll, we'll every question for a poll.
# Select: 
# => poll.*
# => num_questions: COUNT(DISTINCT questions.id)
# => num_responses:
# =>   * sometimes response will be present (if they chose that answer choice)
# =>   * othertimes it'll be NULL (if they didn't)
# =>   * COUNT(responses.id)
