# == Schema Information
#
# Table name: questions
#
#  id       :integer          not null, primary key
#  poll_id  :integer          not null
#  question :text             not null
#

class Question < ActiveRecord::Base
  belongs_to(
    :poll,
    class_name: "Poll",
    primary_key: :id,
    foreign_key: :poll_id
  )
  
  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    primary_key: :id,
    foreign_key: :question_id
  )
  
  validates :poll_id, :question, presence: true
  
  def results
    choices = self.answer_choices.includes(:responses)
    response_counts = Hash.new {0}
    choices.each do |choice|
      response_counts[choice] = choice.responses.length
    end
    return response_counts
  end
end
