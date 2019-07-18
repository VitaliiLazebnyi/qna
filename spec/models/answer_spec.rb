# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it do
    should have_one(:best_of)
      .class_name('Question')
      .dependent(:nullify)
      .with_foreign_key('best_answer_id')
  end

  context 'check circular dependency absence' do
    let!(:answer) { create :answer }
    let!(:question) { answer.question }

    it 'possible to destroy' do
      question.update!(best_answer_id: answer.id)
      expect { answer.destroy! }
          .to not_change(Question, :count)
          .and change(Answer, :count).by(-1)
    end
  end
end
