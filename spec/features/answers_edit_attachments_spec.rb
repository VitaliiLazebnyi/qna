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

  describe 'authentificated user' do
    scenario 'can edit his answer and add attachments', js: true do
      login answerer

      visit question_path(answer.question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'answer_body', with: edited_answer.body
        attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'
      end

      within '.answers' do
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end
    end
  end
end
