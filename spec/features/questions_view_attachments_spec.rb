# frozen_string_literal: true

require 'rails_helper'

feature 'User can view question', '
  To help others
  User can view a question
' do
  given(:user)      { create :user }
  given!(:question) { create :question, :with_file, user: user }
  given!(:answer_1) { create :answer, user: user, question: question }
  given!(:answer_2) { create :answer, user: user, question: question }

  scenario "visitor can't remove attachments", js: true do
    visit question_path(question)

    expect(page).to have_content 'rails_helper.rb'
  end

  scenario "visitor can't remove attachments", js: true do
    visit question_path(question)

    within '.question .attachments' do
      expect(page).to_not have_link 'Remove'
    end
  end

  scenario 'user can remove attachments', js: true do
    login user
    visit question_path(question)

    within '.question .attachments' do
      click_on 'Remove'
    end

    expect(page).to_not have_content 'rails_helper.rb'
  end
end
