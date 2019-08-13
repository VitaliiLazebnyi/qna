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
  given(:award_invalid) { build(:award, title: '1', url: '1') }

  scenario 'authenticated user creates a question with valid award', js: true do
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
      expect(page.find('#award img')['src']).to have_content award.url
    end
    expect(page).to_not have_content 'Award url is invalid'
    expect(Award.last.user).to be_nil
  end

  scenario 'authenticated user creates a question with invalid award', js: true do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    within '.award_fields' do
      fill_in 'Award title', with: award_invalid.title
      fill_in 'Url', with: award_invalid.url
    end

    click_on 'create'

    expect(page).to_not have_css('#award')
    expect(page).to have_content 'Award url is invalid'
  end
end
