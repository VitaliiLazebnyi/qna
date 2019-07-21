# frozen_string_literal: true

require 'rails_helper'

feature 'User can answer the question', '
  In order to share his knowledge
  User can answer some question
' do
  given(:questioner) { create :user }
  given(:answerer)   { create :user }
  given(:question)   { create :question, user: questioner }
  given(:answer)     { build  :answer }

  scenario 'authenticated user creates an answer', js: true do
    login answerer

    visit question_path(question)
    fill_in :answer_body, with: answer.body
    click_on 'answer'

    expect(page).to have_content 'Your answer was successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'authenticated user creates an answer with mistakes', js: true do
    login answerer

    visit question_path(question)
    click_on 'answer'

    expect(page).to have_content 'error(s) detected'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'unauthenticated user creates a question', js: true do
    visit question_path(question)
    expect(page).to_not have_content 'answer'
  end
end
