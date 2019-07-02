# frozen_string_literal: true

require 'rails_helper'

feature 'User can create questions', '
  In order to get an answer from community
  User can ask questions
' do

  given(:user)     { FactoryBot.create(:user) }
  given(:question) { FactoryBot.build(:question) }

  scenario 'authenticated user creates a question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', question.title
    fill_in 'Body', question.body
    click_on 'Create'

    expect(page).to have_content 'Your question was successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'authenticated user creates a question with errors' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    click_on 'Create'

    expect(page).to have_content 'Errors'
    expect(page).to have_content "Title can't be empty"
    expect(page).to have_content "Body can't be empty"
  end

  scenario 'unauthenticated user creates a question' do

  end

  # scenario 'User can create a Question'
  # scenario "Unauthorized user can't create a Question"
  # scenario 'User can see list of questions'
  # scenario 'User can see the Questions and its answers.'
  # scenario 'User can remove his question'
  # scenario "User can't remove others questions"
end
