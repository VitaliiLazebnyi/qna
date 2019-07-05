# frozen_string_literal: true

require 'rails_helper'

feature 'User can view question', '
  To help others
  User can view a question
' do

  given(:user)      { create :user }
  given!(:question) { create :question, user: user }

  scenario 'user can view a question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
