# frozen_string_literal: true

require 'rails_helper'

feature 'User can answer the question', '
  In order to share his knowledge
  User can answer some question
' do
  given(:questioner) { create :user }
  given(:answerer)   { create :user }
  given(:question)   { create :question, user: questioner }
  given(:answer)     { build  :answer }

  scenario 'authenticated user creates an answer with attachments', js: true do
    login answerer

    visit question_path(question)
    fill_in :answer_body, with: answer.body
    attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

    click_on 'answer'

    within '.answers' do
      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end
  end
end
