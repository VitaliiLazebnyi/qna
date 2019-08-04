FactoryBot.define do
  factory :link do
    sequence :title do |n|
      "google.com##{n}"
    end

    sequence :url do |n|
      "https://www.google.com/search?q=#{n}"
    end
  end
end
