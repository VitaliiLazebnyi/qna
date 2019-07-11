# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { "Question Title #{Time.now.to_f}" }
    body { "Question Body #{Time.now.to_f}" }
  end
end
