# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  context 'check circular dependency absence' do
    let!(:answer) { create :answer }
    let!(:question) { answer.question }

    it 'possible to destroy' do
      answer.update!(best: true)
      expect { question.destroy! }
        .to change(Question, :count).by(-1)
                                    .and change(Answer, :count).by(-1)
    end
  end
end
