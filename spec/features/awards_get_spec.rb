# frozen_string_literal: true

require 'rails_helper'

feature 'User can get award if he gave best answer', '
  In order to get feedback how good his answer was
  User can receive best answer award
' do
  given(:user)     { create(:user) }
  given(:award)    { create(:award) }
  given(:question) { award.question }


  scenario 'authenticated user gets award when he gave best answer', js: true do
    login user

    visit question_path(question)
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
  end
end
