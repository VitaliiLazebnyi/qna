# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  context 'check circular dependency absence' do
    let!(:answer) { create :answer }
    let!(:question) { answer.question }

    it 'possible to destroy' do
      answer.update!(best: true)
      expect { answer.destroy! }
        .to not_change(Question, :count)
        .and change(Answer, :count).by(-1)
    end
  end

  describe '#make_best!' do
    context "when there's no best answer" do
      let!(:question) { create :question }
      let!(:answer_1) { create :answer, question: question }
      let!(:answer_2) { create :answer, question: question }

      it 'just sets best to answer and keeps other answers the same' do
        answer_1.make_best!

        answer_1.reload
        answer_2.reload

        expect(answer_1).to be_best
        expect(answer_2).to_not be_best
      end
    end

    context 'when some other answer is already best' do
      let!(:question) { create :question }
      let!(:answer_1) { create :answer, question: question, best: true }
      let!(:answer_2) { create :answer, question: question }

      it 'unset other best of other answers' do
        expect(answer_1).to be_best
        expect(answer_2).to_not be_best

        answer_2.make_best!

        answer_1.reload
        answer_2.reload

        expect(answer_1).to_not be_best
        expect(answer_2).to be_best
      end
    end

    context 'when some other answer is already best' do
      let!(:answer_1) { create :answer }
      let!(:answer_2) { create :answer }

      it 'not influence answers of other questions' do
        expect(answer_1).to_not be_best
        expect(answer_2).to_not be_best

        answer_1.make_best!

        answer_1.reload
        answer_2.reload

        expect(answer_1).to be_best
        expect(answer_2).to_not be_best
      end
    end

    context 'when answer is already best' do
      let!(:answer) { create :answer, best: true }

      it 'keeps answer best' do
        expect(answer).to be_best

        answer.make_best!
        answer.reload

        expect(answer).to be_best
      end
    end
  end
end
