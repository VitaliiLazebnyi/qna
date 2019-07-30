# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the question', '
  In order to add some additional data
  As questioner I can add
  Links to my question
' do

  given(:user) { create(:user) }
  given(:gist_title) { 'My Gist' }
  given(:gist_url) { 'https://gist.github.com/VitaliyLazebny/86d0b284890cefd138f8f2fe210b8c82' }
  given(:question) { build(:question) }

  scenario 'authenticated user creates a question with link' do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body

    fill_in 'Link title', with: gist_title
    fill_in 'url', with: gist_url

    click_on 'create'

    expect(page).to have_link gist_title, href: gist_url
  end

end