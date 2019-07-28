# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question
    user
    body { "Answer Body #{Time.now.to_f}" }

    trait :with_file do
      files { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain')] }
    end
  end
end
