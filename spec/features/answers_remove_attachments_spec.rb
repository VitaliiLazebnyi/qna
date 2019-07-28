# frozen_string_literal: true

require 'rails_helper'

feature 'User can his answer from question', '
  In case is user made mistake in answer
  To fix the mistake
  User can remove his answer
' do
  given(:questioner) { create :user }
  given(:answerer)   { create :user }
  given(:question)   { create :question, user: questioner }
  given!(:answer)    { create :answer, :with_file, question: question, user: answerer }

  scenario 'authenticated user removes attachments from his answer', js: true do
    login answerer

    visit question_path(question)

    within '.attachments' do
      click_on 'Remove'
    end

    expect(page).to_not have_content 'rails_helper.rb'
  end

  scenario 'authenticated user removes others answers attachments', js: true do
    login questioner

    visit question_path(question)
    expect(page).to_not have_link 'Remove'
  end

  scenario "unauthenticated can't remove answers attachments", js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Remove'
  end
end
