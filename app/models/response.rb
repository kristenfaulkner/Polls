# == Schema Information
#
# Table name: responses
#
#  id        :integer          not null, primary key
#  user_id   :integer          not null
#  answer_id :integer          not null
#

class Response < ActiveRecord::Base
  
  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_id,
    primary_key: :id
  )
  
  belongs_to(
    :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )
  
  validates :user_id, :answer_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cannot_respond_to_own_poll
  
  def respondent_has_not_already_answered_question
    my_responses = existing_responses
    unless (my_responses.length == 1 && my_responses.first.id == self.id) || my_responses.empty?
      errors[:respondent] << "You have already answered this question."
    end
  end
  
  def author_cannot_respond_to_own_poll
    unless self_responded_poll.empty?
      errors[:user_id] << "You cannot respond to your own poll"
    end
  end
    
  def self_responded_poll
    Poll.joins(questions: [ { answer_choices: :responses } ])
      .where('polls.author_id = ?', self.user_id)
  end
  
  def existing_responses
    Response.find_by_sql([
      'SELECT *
      FROM responses
      JOIN answer_choices
      ON responses.answer_id = answer_choices.id
      WHERE responses.user_id = ?
      AND answer_choices.question_id IN
      (
            SELECT questions.id
            FROM answer_choices
            JOIN questions
            ON questions.id = answer_choices.question_id
            WHERE answer_choices.id = ?
      )', self.user_id, self.answer_id
    ])
  end
end