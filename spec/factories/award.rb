# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    question { create :question }

    sequence :title do |n|
      "google.com##{n}"
    end

    sequence :url do |n|
      "https://www.google.com/search?q=#{n}"
    end

    # after :create do |a|
    #   a.user = a.question.user
    # end
  end
end
