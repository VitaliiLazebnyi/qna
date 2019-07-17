# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  belongs_to :best_answer, class_name: "Answer", optional: true

  has_many :answers, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
end
