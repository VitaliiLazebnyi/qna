# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_one_attached :file

  validates :title, presence: true
  validates :body, presence: true
end
