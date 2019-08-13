# frozen_string_literal: true

require 'rails_helper'

feature 'User can remove links when he edits his question', '
  In order to avoid outdated date
  User can remove his links
  By edition his question
' do
  let(:question) { create :question }
  let(:user)     { question.user }
  let(:link)     { question.links.first }

  scenario 'user removes his links', js: true do
    login user

    visit question_path(question)
    expect(page).to have_link link.title

    within '.question' do
      click_on 'Edit'
      click_on 'remove link'
      click_on 'Save'
    end

    expect(page).to_not have_link link.title
  end
end
