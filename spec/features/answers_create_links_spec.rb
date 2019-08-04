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
  given(:link_1)       { build(:link) }
  given(:link_2)       { build(:link) }

  scenario 'authenticated user creates a answer with link', js: true do
    login answerer

    visit question_path(question)
    fill_in :answer_body, with: answer.body

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

    click_on :answer

    within '.answers' do
      expect(page).to have_link link_1.title, href: link_1.url
      expect(page).to have_link link_2.title, href: link_2.url
    end
  end
end
