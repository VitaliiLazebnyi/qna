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

  scenario 'authenticated user creates a question with award', js: true do
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

    within '.award_fields' do
      fill_in 'Link title', with: award_invalid.title
      fill_in 'Url', with: award_invalid.url
    end

    click_on 'create'

    within '.question' do
      expect(page).to_not has_css('#award');
    end
    expect(page).to have_content 'Award url is invalid'
    expect(page).to have_content 'Award title is invalid'
  end
end
