# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }

    context 'logged in user' do
      before { login(question.user) }

      context 'with valid parameters' do
        let(:answer) { attributes_for :answer }

        it 'saves new answer to database' do
          expect { post :create, params: { answer: answer, question_id: question.id }, format: :js }
            .to change(Answer, :count).by(1)
        end

        it 'new answer is linked to user' do
          post :create, params: { answer: answer, question_id: question.id }, format: :js
          expect(assigns(:answer).user_id).to eq question.user.id
        end

        it 'new answer is linked to question' do
          post :create, params: { answer: answer, question_id: question.id }, format: :js
          expect(assigns(:answer).question_id).to eq question.id
        end

        it 'new answer has proper body' do
          post :create, params: { answer: answer, question_id: question.id }, format: :js
          expect(assigns(:answer).body).to eq answer[:body]
        end

        it 'renders create template' do
          post :create, params: { answer: answer, question_id: question.id }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid parameters' do
        let(:answer) { attributes_for :answer, body: nil }

        it 'not saves new answer to database' do
          expect { post :create, params: { answer: answer, question_id: question.id }, format: :js }
            .to_not change(Answer, :count)
        end

        it 'renders create template' do
          post :create, params: { answer: answer, question_id: question.id }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'visitor creates answer' do
      let(:answer) { attributes_for :answer }

      it 'not saves new answer to database' do
        expect { post :create, params: { answer: answer, question_id: question.id }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: answer, question_id: question.id }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create :answer }

    context 'logged in user' do
      before { login(answer.user) }

      context 'with valid parameters' do
        let(:edited_answer) { attributes_for :answer }

        it 'changes answer attributes' do
          put :update, params: { id: answer.id, answer: edited_answer }, format: :js
          answer.reload
          expect(answer.body).to eq edited_answer[:body]
        end

        it 'leaves same answers number as was' do
          expect { patch :update, params: { id: answer, answer: edited_answer }, format: :js }
            .to_not change(Answer, :count)
        end

        it 'renders update template' do
          patch :update, params: { id: answer, answer: edited_answer }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid parameters' do
        let(:edited_answer) { attributes_for :answer, body: nil }

        it 'changes answer attributes' do
          expect do
            put :update, params: { id: answer.id, answer: edited_answer }, format: :js
            answer.reload
          end.to_not change(answer, :body)
        end

        it 'leaves same answers number as was' do
          expect { put :update, params: { id: answer.id, answer: edited_answer }, format: :js }
            .to_not change(Answer, :count)
        end

        it 'renders update template' do
          put :update, params: { id: answer.id, answer: edited_answer }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'user tries to change someone else answer' do
      let(:user)          { create(:user) }
      let(:edited_answer) { attributes_for :answer }
      before { login(user) }

      it 'not changes answer attributes' do
        old_body = answer.body
        put :update, params: { id: answer.id, answer: edited_answer }, format: :js
        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'leaves same answers number as was' do
        expect { patch :update, params: { id: answer, answer: edited_answer }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'redirects to view page' do
        put :update, params: { id: answer.id, answer: edited_answer }, format: :js
        expect(response.body).to eq IO.binread(File.join(Rails.root, 'public/403.html'))
      end

      it 'returns forbidden http status code' do
        put :update, params: { id: answer.id, answer: edited_answer }, format: :js
        expect(response).to have_http_status(403)
      end
    end

    context 'visitor tries to edit question' do
      let(:edited_answer) { attributes_for :answer }

      it 'not changes answer attributes' do
        old_body = answer.body
        put :update, params: { id: answer.id, answer: edited_answer }, format: :js
        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'leaves same answers number as was' do
        expect { patch :update, params: { id: answer, answer: edited_answer }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: edited_answer }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'PATCH #best_answer' do
    let!(:answer) { create :answer }
    let(:question) { answer.question }

    context 'question owner' do
      let(:user) { question.user }
      before { login(user) }

      it 'changes answer attributes' do
        patch :make_best, params: { id: answer.id }, format: :js
        answer.reload
        expect(answer).to be_best
      end

      it 'leaves same answers number as was' do
        expect { patch :make_best, params: { id: answer.id }, format: :js }
          .to not_change(Answer, :count)
          .and not_change(Question, :count)
      end

      it 'renders update template' do
        patch :make_best, params: { id: answer.id }, format: :js
        expect(response).to render_template :make_best
      end
    end

    context 'other user' do
      let(:user) { answer.user }
      before { login(user) }

      it 'not changes answer best status' do
        patch :make_best, params: { id: answer.id }, format: :js
        question.reload
        answer.reload
        expect(answer.best?).to eq false
      end

      it 'leaves same answers number as was' do
        expect { patch :make_best, params: { id: answer.id }, format: :js }
          .to not_change(Answer, :count)
          .and not_change(Question, :count)
      end

      it 'redirects to view page' do
        patch :make_best, params: { id: answer.id }, format: :js
        expect(response.body).to eq IO.binread(File.join(Rails.root, 'public/403.html'))
      end

      it 'returns forbidden http status code' do
        patch :make_best, params: { id: answer.id }, format: :js
        expect(response).to have_http_status(403)
      end
    end

    context 'visitor' do
      it 'not changes answer attributes' do
        patch :make_best, params: { id: answer.id }, format: :js
        question.reload
        answer.reload
        expect(answer.best?).to eq false
      end

      it 'leaves same answers number as was' do
        expect { patch :make_best, params: { id: answer.id }, format: :js }
          .to not_change(Answer, :count)
          .and not_change(Question, :count)
      end

      it 'renders update template' do
        patch :make_best, params: { id: answer.id }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create :user }
    let(:user)   { create :user }
    let!(:question) { create :question, user: author }
    let!(:answer)   { create :answer, user: author, question: question }
    context 'author removes his answer' do
      before { login(author) }

      it 'saves new answer to database' do
        expect { delete :destroy, params: { id: answer.id }, format: :js }
          .to change(Answer, :count).by(-1)
      end

      it 'redirects to view page' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to redirect_to answer
      end
    end

    context "user can't remove others questions" do
      before { login(user) }

      it 'saves new answer to database' do
        expect { delete :destroy, params: { id: answer.id }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'redirects to view page' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.body).to eq IO.binread(File.join(Rails.root, 'public/403.html'))
      end

      it 'returns forbidden http status code' do
        delete :destroy, params: { id: answer.id }, format: :js
        expect(response).to have_http_status(403)
      end
    end

    context "visitor can't remove others questions" do
      it 'not changes answers number' do
        expect { delete :destroy, params: { id: answer.id }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'proper error message' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end

      it 'returns redirect http status code' do
        delete :destroy, params: { id: answer.id }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
