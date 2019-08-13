# frozen_string_literal: true

require 'rails_helper'

feature 'User can get award if he gave best answer', '
  In order to get feedback how good his answer was
  User can receive best answer award
' do
  given(:user)     { create(:user) }
  given!(:award_1) { create(:award, user: user) }
  given!(:award_2) { create(:award, user: user) }

  scenario 'authenticated user gets award when he gave best answer', js: true do
    login user

    visit awards_path

    expect(page).to have_content award_1.question.title
    expect(page).to have_content award_1.title
    expect(page).to have_css("img[src*='#{award_1.url}']")
    expect(page).to have_content award_2.question.title
    expect(page).to have_content award_2.title
    expect(page).to have_css("img[src*='#{award_2.url}']")
  end
end
