# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to the answer', '
  In order to add some additional data
  As answerer I can add
  Links to my answer
' do
  given(:answerer)   { create(:user) }
  given(:question)   { create(:question) }
  given(:answer)     { build(:answer) }
  given(:gist_title) { 'My Gist' }
  given(:gist_url)   { 'https://gist.github.com/VitaliyLazebny/86d0b284890cefd138f8f2fe210b8c82' }

  scenario 'authenticated user creates a answer with link', js: true do
    login answerer

    visit question_path(question)
    fill_in :answer_body, with: answer.body
    fill_in 'Link title', with: gist_title
    fill_in 'Url', with: gist_url
    click_on 'answer'

    within '.answers' do
      expect(page).to have_link gist_title, href: gist_url
    end
  end
end
