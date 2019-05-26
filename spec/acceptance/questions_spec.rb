# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Questions', type: :acceptance do
  scenario 'User can create a Question'
  scenario "Unauthorized user can't create a Question"
  scenario 'User can see list of questions'
  scenario 'User can see the Questions and its answers.'
  scenario 'User can remove his question'
  scenario "User can't remove others questions"
end
