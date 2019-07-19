# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  default_scope { order(best: :desc) }

  def make_best!
    question.answers.update_all(best: false)
    reload
    update(best: true)
  end
end
