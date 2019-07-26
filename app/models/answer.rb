# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true


  default_scope { order(best: :desc) }

  def make_best!
    transaction do
      question.answers.where.not(id: id).update_all(best: false)
      update!(best: true)
    end
  end
end
