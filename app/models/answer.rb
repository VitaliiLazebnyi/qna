# frozen_string_literal: true

class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank

  default_scope { order(best: :desc) }

  def make_best!
    transaction do
      question.answers.where.not(id: id).update_all(best: false)
      update!(best: true)
    end
  end
end
