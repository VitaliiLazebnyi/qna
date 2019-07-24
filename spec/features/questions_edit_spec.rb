# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', '
  In order to correct his mistake
  User can edit his questions
' do
  given(:question)        { create :question }
  given(:edited_question) { attributes_for :question }
  given(:asker)           { question.user }
  given(:other_user)      { create :user }

  scenario "unauthorized user can't edit any questions" do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'authentificated user' do
    scenario 'can edit his question with valid body', js: true do
      login asker

      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'question_title', with: edited_question[:title]
        fill_in 'question_body',  with: edited_question[:body]
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content edited_question[:title]
        expect(page).to have_content edited_question[:body]
      end
    end

    scenario 'can add files to his question', js: true do
      login asker

      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        attach_file 'Files', %W(#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb)
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario "can't edit his answer with invalid body", js: true do
      login asker

      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'question_title', with: ''
        fill_in 'question_body',  with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content 'error(s) detected'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario "can't edit others questions" do
      login other_user

      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
