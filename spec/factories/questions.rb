# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    user
    title { "Question Title #{Time.now.to_f}" }
    body { "Question Body #{Time.now.to_f}" }

    trait :with_file do
      files { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain')] }
    end
  end
end
