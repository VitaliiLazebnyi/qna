class Link < ApplicationRecord
  validates :title, :url, presence: true

  belongs_to :question
end
