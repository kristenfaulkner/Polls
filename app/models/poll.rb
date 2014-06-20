# == Schema Information
#
# Table name: polls
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  author_id  :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Poll < ActiveRecord::Base
  belongs_to(
    :author,
    class_name: "User",
    primary_key: :id,
    foreign_key: :author_id
  )
  
  has_many(
    :questions,
    class_name: "Question",
    primary_key: :id,
    foreign_key: :poll_id
  )
  
  def num_questions
    self.questions.length
  end
  
  validates :title, :author_id, presence: true
end
