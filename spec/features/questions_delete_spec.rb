# frozen_string_literal: true

require 'rails_helper'

feature 'User can remove a question', '
  To help others
  User can view a question
' do
  given(:owner)     { create :user }
  given(:user)      { create :user }
  given!(:question) { create :question, user: owner }

  scenario 'user can remove his question' do
    login owner
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Your question was successfully removed.'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario "user can't remove others questions" do
    login user
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end

  scenario "visitor can't remove a question" do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
end
