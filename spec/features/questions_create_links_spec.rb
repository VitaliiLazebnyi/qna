# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the question', '
  In order to add some additional data
  As questioner I can add
  Links to my question
' do
  given(:user)     { create(:user) }
  given(:link)     { build(:link) }
  given(:question) { build(:question) }

  scenario 'authenticated user creates a question with link', js: true do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    fill_in 'Link title', with: link.title
    fill_in 'Url', with: link.url

    click_on 'create'

    within '.question' do
      expect(page).to have_link link.title, href: link.url
    end
  end
end
