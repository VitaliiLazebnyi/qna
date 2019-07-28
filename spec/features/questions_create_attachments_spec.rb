# frozen_string_literal: true

require 'rails_helper'

feature 'User can create questions', '
  In order to get an answer from community
  User can ask questions
' do
  given(:user)     { create(:user) }
  given(:question) { build(:question) }

  scenario 'user asks questions with attached file' do
    login user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

    click_on 'create'

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end
