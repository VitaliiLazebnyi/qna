# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { accept_nested_attributes_for :links }

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

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
