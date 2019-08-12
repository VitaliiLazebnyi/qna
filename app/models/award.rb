# frozen_string_literal: true

class Award < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :title, presence: true
  validates :url,
            format: { with: /https?:\/\/[\w.]+/i },
            presence: true
end
