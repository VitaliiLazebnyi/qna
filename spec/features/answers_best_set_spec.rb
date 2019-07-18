# frozen_string_literal: true

require 'rails_helper'

feature 'User can choose the best answer', '
  To award most helpful answer user can make it "best"
' do
  given(:question) { create :question}

  context 'no best answer', js: true do
    given!(:answer_1) { create :answer, question: question }
    given!(:answer_2) { create :answer, question: question }
    given!(:answer_3) { create :answer, question: question }

    scenario 'user can set best answer' do
      login question.user
      visit question_path(question)

      expect(body).to_not have_content "The best answer!"
      expect(answer_1.body).to appear_before answer_2.body
      expect(answer_2.body).to appear_before answer_3.body

      within "#answer-#{answer_2.id}" do
        click_on 'Make best'
      end

      within "#answer-#{answer_2.id}" do
        expect(body).to have_content "The best answer!"
      end

      expect(answer_2.body).to appear_before answer_1.body
      expect(answer_1.body).to appear_before answer_3.body
    end
  end

  context 'there is some best answer', js: true do
    given!(:answer_1) { create :answer, question: question }
    given!(:answer_2) {
      a = create :answer, question: question
      question.update!(best_answer_id: a.id)
      a
    }
    given!(:answer_3) { create :answer, question: question }

    scenario 'best answer is on top' do
      visit question_path(question)

      expect(answer_2.body).to appear_before answer_1.body
      expect(answer_1.body).to appear_before answer_3.body
    end

    scenario 'user can set best answer' do
      login question.user
      visit question_path(question)

      within "#answer-#{answer_3.id}" do
        click_on 'Make best'
      end

      sleep 0.2
      expect(answer_3.body).to appear_before answer_1.body
      expect(answer_1.body).to appear_before answer_2.body
    end
  end

  context 'visitor' do
    scenario "can't set best answer" do
      visit question_path(question)

      expect(page).to_not have_link 'Make best'
    end
  end

  context 'other user' do
    let(:other_user) { create :user }

    scenario "can't set best answer" do
      login other_user
      visit question_path(question)

      expect(page).to_not have_link 'Make best'
    end
  end
end
