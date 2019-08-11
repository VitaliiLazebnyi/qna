# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the question', '
  In order to add some additional data
  As questioner I can add
  Links to my question
' do
  given(:user)       { create(:user) }
  given(:question)   { build(:question) }
  given(:question_2) { create :question, user: user }
  given(:link_1)     { build(:link) }
  given(:link_2)     { build(:link) }
  given(:gist)       { build(:link, :gist) }

  scenario 'authenticated user creates a question with links', js: true do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    within '.link_fields' do
      fill_in 'Link title', with: link_1.title
      fill_in 'Url', with: link_1.url
      click_on 'add link'
    end

    second_link_fields = find_all(".link_fields .nested-fields").last
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

  scenario 'authenticated user creates a question with gist links', js: true do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    within '.link_fields' do
      fill_in 'Link title', with: gist.title
      fill_in 'Url', with: gist.url
      click_on 'add link'
    end

    click_on 'create'

    within '.question' do
      expect(page).to have_link gist.title, href: gist.url
      expect(page).to have_content 'CREATE DATABASE test_guru;'
    end
    expect(page).to_not have_content 'Links url is invalid'
  end

  scenario 'authenticated user creates a question with invalid link', js: true do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    within '.link_fields' do
      fill_in 'Link title', with: link_1.title
      fill_in 'Url', with: 'invalid_link'
    end

    click_on 'create'

    expect(page).to_not have_link link_1.title, href: 'invalid_link'
    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'authenticated user add a link to question during question edit', js: true do
    login user

    visit question_path(question_2)

    within '.question' do
      click_on 'Edit'
    end

    within '.question .link_fields' do
      fill_in 'Link title', with: link_1.title
      fill_in 'Url', with: link_1.url
    end

    click_on 'Save'

    expect(page).to have_link link_1.title, href: link_1.url
    expect(page).to_not have_content 'Links url is invalid'
  end
end
