# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { "Answer Body #{Time.now.to_f}" }
  end
end
