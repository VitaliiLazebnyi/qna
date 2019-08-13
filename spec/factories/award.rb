# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    user
    question { create :question, user: user}

    sequence :title do |n|
      "google.com##{n}"
    end

    sequence :url do |n|
      "https://www.google.com/search?q=#{n}"
    end
  end
end
