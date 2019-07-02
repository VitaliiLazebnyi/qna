# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "name#{Time.now.to_f + 1}@mail.com" }
    password { 'Passw0rd!1' }
  end
end
