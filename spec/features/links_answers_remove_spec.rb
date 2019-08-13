# frozen_string_literal: true

require 'rails_helper'

feature 'User can remove links when he edits his answer', '
  In order to avoid outdated date
  User can remove his links
  By edition his answer
' do
  let(:answer)   { create :answer }
  let(:question) { answer.question }
  let(:user)     { answer.user }
  let(:link)     { answer.links.first }

  scenario 'user removes his links', js: true do
    login user

    visit question_path(question)
    expect(page).to have_link link.title

    within '.answers' do
      click_on 'Edit'
      click_on 'remove link'
      click_on 'Save'
    end

    expect(page).to_not have_link link.title
  end
end
