# frozen_string_literal: true

require 'rails_helper'

feature 'User can his answer from question', '
  In case is user made mistake in answer
  To fix the mistake
  User can remove his answer
' do

  given(:questioner) { create :user }
  given(:answerer)   { create :user }
  given(:question)   { create :question, user: questioner }
  given!(:answer)    { create :answer, question: question, user: answerer }

  scenario 'authenticated user removes his answer' do
    login answerer

    visit question_path(question)

    expect(page).to have_content answer.body
    click_on 'Delete answer'
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'authenticated user removes others answer' do
    login questioner

    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Delete answer'
  end

  scenario "unauthenticated can't remove answers" do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content 'Delete answer'
  end
end
