# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the question', '
  In order to add some additional data
  As questioner I can add
  Links to my question
' do
  given(:user)          { create(:user) }
  given(:question)      { build(:question) }
  given(:award)         { build(:award) }
  given(:award_invalid) { build(:award, title: '', url: '') }

  scenario 'authenticated user creates a question with links', js: true do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    within '.award_fields' do
      fill_in 'Award title', with: award.title
      fill_in 'Url', with: award.url
    end

    click_on 'create'

    within '.question' do
      expect(page.find('#award')['src']).to have_content award.url
    end
    expect(page).to_not have_content 'Award url is invalid'
    expect(page).to_not have_content 'Award title is invalid'
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
      # page.has_css?("button #popUpButton")
      # expect(page.find('#award')['src']).to_not have_content award.url
    end
    expect(page).to_not have_content 'Award url is invalid'
    expect(page).to_not have_content 'Award title is invalid'
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
