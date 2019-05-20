FactoryBot.define do
  factory :answer do
    body { "Answer Body #{Time.now.to_i}" }
  end
end
