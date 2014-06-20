# == Schema Information
#
# Table name: answer_choices
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  answer      :text             not null
#

class AnswerChoice < ActiveRecord::Base
  belongs_to(
    :question,
    class_name: "Question",
    primary_key: :id,
    foreign_key: :question_id
  )
  
  has_many(
    :responses,
    class_name: "Response",
    primary_key: :id,
    foreign_key: :answer_id
  )
  
  validates :question_id, :answer, presence: true
end
