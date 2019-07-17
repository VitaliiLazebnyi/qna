# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_one :best_of,
          class_name: 'Question',
          foreign_key: 'best_answer_id',
          dependent: :nullify

  validates :body, presence: true
end
