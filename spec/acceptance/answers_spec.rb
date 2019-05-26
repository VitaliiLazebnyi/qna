# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Answers', type: :acceptance do
  scenario 'User can answer the Question'
  scenario 'User can remove his answer'
  scenario "User can't remove others answers"
end
