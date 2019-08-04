# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the question', '
  In order to add some additional data
  As questioner I can add
  Links to my question
' do
  given(:user)     { create(:user) }
  given(:question) { build(:question) }
  given(:link_1)   { build(:link) }
  given(:link_2)   { build(:link) }

  scenario 'authenticated user creates a question with links', js: true do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    within '#links' do
      fill_in 'Link title', with: link_1.title
      fill_in 'Url', with: link_1.url
      click_on 'add link'
    end

    second_link_fields = find_all("#links .nested-fields").last
    within second_link_fields do
      fill_in 'Link title', with: link_2.title
      fill_in 'Url', with: link_2.url
    end

    click_on 'create'

    within '.question' do
      expect(page).to have_link link_1.title, href: link_1.url
      expect(page).to have_link link_2.title, href: link_2.url
    end
    expect(page).to_not have_content 'Links url is invalid'
  end

  scenario 'authenticated user creates a question with invalid link', js: true do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    within '#links' do
      fill_in 'Link title', with: link_1.title
      fill_in 'Url', with: 'invalid_link'
    end

    click_on 'create'

    expect(page).to_not have_link link_1.title, href: 'invalid_link'
    expect(page).to have_content 'Links url is invalid'
  end
end
