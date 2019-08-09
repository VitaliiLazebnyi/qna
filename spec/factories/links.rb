# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    sequence :title do |n|
      "google.com##{n}"
    end

    sequence :url do |n|
      "https://www.google.com/search?q=#{n}"
    end

    trait :gist do
      title { 'gist' }
      url   { 'https://gist.github.com/VitaliyLazebny/8248b2620e839fdb1e5fcf3c8c0906fc' }
    end
  end
end
