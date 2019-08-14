# frozen_string_literal: true

require 'rails_helper'

feature 'User can get award if he gave best answer', '
  In order to get feedback how good his answer was
  User can receive best answer award
' do
  given(:question)   { create :question }
  given(:questioner) { question.user }

  given(:user)       { create :user }
  given(:answer)     { build  :answer }

  context 'get unused award' do
    given!(:award) { create :award, question: question, user: nil }

    scenario 'authenticated user gets award when he gave best answer', js: true do
      login user

      visit question_path(question)
      fill_in :answer_body, with: answer.body
      click_on 'answer'

      logout
      login questioner

      visit question_path(question)
      click_on 'Make best'
      logout

      login user
      visit awards_path
      expect(page).to have_content award.question.title
      expect(page).to have_content award.title
      expect(page).to have_css("img[src*='#{award.url}']")
    end
  end

  context 'get used award' do
    given!(:answer_2) { create :answer, best: true, question: question }
    given!(:award)    { create :award, question: question, user: answer_2.user }

    scenario 'authenticated user gets award when he gave best answer', js: true do
      expect(award.user).to eq answer_2.user

      login user
      visit awards_path
      expect(page).to_not have_content award.question.title
      expect(page).to_not have_content award.title
      expect(page).to_not have_css("img[src*='#{award.url}']")

      visit question_path(question)
      fill_in :answer_body, with: answer.body
      click_on 'answer'

      logout
      login questioner

      visit question_path(question)
      click_on 'Make best'
      logout

      login user
      visit awards_path
      expect(page).to have_content award.question.title
      expect(page).to have_content award.title
      expect(page).to have_css("img[src*='#{award.url}']")
    end
  end
end
