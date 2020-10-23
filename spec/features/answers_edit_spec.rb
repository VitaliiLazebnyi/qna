# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit the answer', '
  In order to correct his mistake
  User can edit his answers
' do
  given(:answer)        { create :answer }
  given(:edited_answer) { build :answer  }
  given(:answerer)      { answer.user    }
  given(:other_user)    { create :user   }

  scenario "unauthorized user can't edit any answers" do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Edit answer'
  end

  describe 'authentificated user' do
    scenario 'can edit his answer with valid body', js: true do
      login answerer

      visit question_path(answer.question)

      click_on 'Edit'

      within '#answers' do
        fill_in 'answer_body', with: edited_answer.body
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea#answer_body'
        expect(page).to have_content edited_answer.body
      end
    end

    scenario "can't edit his answer with invalid body", js: true do
      login answerer

      visit question_path(answer.question)

      click_on 'Edit'

      within '#answers' do
        fill_in 'answer_body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content 'error(s) detected'
      expect(page).to have_content "Body can't be blank"
    end

    scenario "can't edit others answers", js: true do
      login other_user
      visit question_path(answer.question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
