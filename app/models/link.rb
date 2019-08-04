class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :title, presence: true
  validates :url,
            format: { with: /https?:\/\/[\w.]+/i },
            presence: true
end