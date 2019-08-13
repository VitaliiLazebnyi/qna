# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :title, presence: true
  validates :url,
            format: { with: %r{https?://[\w.]+}i },
            presence: true
end
