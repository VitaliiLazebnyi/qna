# frozen_string_literal: true

require 'rails_helper'

feature 'User can create questions', '
  In order to get an answer from community
  User can ask questions
' do

  given(:user)     { create(:user) }
  given(:question) { build(:question) }

  scenario 'authenticated user creates a question' do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on :create

    expect(page).to have_content 'Your question was successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'authenticated user creates a question with errors' do
    login user

    visit questions_path
    click_on 'Ask question'
    click_on :create

    expect(page).to have_content 'error'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'unauthenticated user creates a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  # scenario 'User can see the Questions and its answers.'
  # scenario 'User can remove his question'
  # scenario "User can't remove others questions"
end
