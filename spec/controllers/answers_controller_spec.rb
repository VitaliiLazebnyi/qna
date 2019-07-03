# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }

    context 'with valid parameters' do
      let(:answer) { attributes_for(:answer) }

      it 'saves new answer to database' do
        expect { post :create, params: { answer: answer, question_id: question.id } }
          .to change(Answer, :count).by(1)

        expect(question&.answers&.first&.body).to eq answer[:body]
      end

      it 'redirects to view page' do
        post :create, params: { answer: answer, question_id: question.id }
        expect(response).to redirect_to [question, assigns(:answer)]
      end
    end

    context 'with invalid parameters' do
      let(:answer) { attributes_for(:answer, body: nil) }

      it 'saves new answer to database' do
        expect { post :create, params: { answer: answer, question_id: question.id } }
          .to_not change(Answer, :count)
      end

      it 'displays new template' do
        post :create, params: { answer: answer, question_id: question.id }
        expect(response).to render_template :new
      end
    end
  end
end
