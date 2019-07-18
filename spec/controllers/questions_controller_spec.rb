# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    it 'loads questions from database' do
      question = create(:question, user: create(:user))
      get :index
      expect(assigns(:questions)).to eq([question])
    end

    it 'renders proper page' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }
    before { login(user) }

    it 'allocates question variable' do
      get :new
      expect(assigns(:question)).to be_instance_of(Question)
    end

    it 'renders proper page' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    before { login(user) }

    it 'allocates question variable' do
      get :edit, params: { id: question.id }
      expect(assigns(:question)).to eq question
    end

    it 'renders proper page' do
      get :edit, params: { id: question.id }
      expect(response).to render_template :edit
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'allocates question variable' do
      get :show, params: { id: question.id }
      expect(assigns(:question)).to eq question
    end

    it 'renders proper page' do
      get :show, params: { id: question.id }
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    before { login(user) }

    context 'with valid parameters' do
      let(:question) { attributes_for(:question) }

      it 'saves new question to database' do
        expect { post :create, params: { question: question } }
          .to change(Question, :count).by(1)
      end

      it 'links new question to logged in user' do
        post :create, params: { question: question }
        expect(assigns(:question).user_id).to eq user.id
      end

      it 'redirects to view page' do
        post :create, params: { question: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid parameters' do
      let!(:question) { attributes_for(:question, title: nil, body: nil) }

      it 'not saves new question to database' do
        expect { post :create, params: { question: question } }
          .to_not change(Question, :count)
      end

      it 'displays new template' do
        post :create, params: { question: question }
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #update' do
    let(:owner) { create(:user) }
    let!(:question) { create(:question, user: owner) }
    let(:question_params) { attributes_for(:question, title: 'Updated title', body: 'Updated body') }
    let(:question_invalid_params) { attributes_for(:question, title: nil, body: nil) }

    context 'can update his own questions' do
      before { login(owner) }

      it 'keeps questions number same' do
        expect { patch :update, params: { id: question.id, question: question_params }, format: :js }
          .to_not change(Question, :count)
      end

      it 'redirects to view page' do
        patch :update, params: { id: question.id, question: question_params }, format: :js
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "can't update his questions with invalid parameters" do
      before { login(owner) }

      it 'keeps questions number same' do
        expect { patch :update, params: { id: question.id, question: question_invalid_params }, format: :js }
          .to_not change(Question, :count)
      end

      it 'redirects to view page' do
        patch :update, params: { id: question.id, question: question_invalid_params }, format: :js
        expect(response).to render_template 'questions/update'
      end
    end

    context "can't update others questions" do
      let(:user) { create(:user) }
      before { login(user) }

      it 'keeps questions number same' do
        expect { patch :update, params: { id: question.id, question: question_params }, format: :js }
          .to_not change(Question, :count)
      end

      it 'redirects to forbidden page' do
        patch :update, params: { id: question.id, question: question_params }, format: :js
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
      end

      it 'returns forbidden http status code' do
        patch :update, params: { id: question.id, question: question_params }, format: :js
        expect(response).to have_http_status(403)
      end
    end

    context "visitor can't edit questions" do
      it 'keeps questions number same' do
        expect { patch :update, params: { id: question.id, question: question_params }, format: :js }
          .to_not change(Question, :count)
      end

      it 'redirects to view page' do
        patch :update, params: { id: question.id, question: question_params }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end

      it 'redirects to view page' do
        patch :update, params: { id: question.id, question: question_params }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end

  # ============
  #
  describe 'PATCH #best_answer' do
    let!(:answer) { create :answer }
    let(:question) { answer.question }

    context 'question owner' do
      let(:user) { question.user }
      before { login(user) }

      it 'changes answer attributes' do
        patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js
        question.reload
        answer.reload
        expect(answer.best?).to eq true
      end

      it 'leaves same answers number as was' do
        expect { patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js}
            .to not_change(Answer, :count)
            .and not_change(Question, :count)
      end

      it 'renders update template' do
        patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js
        expect(response).to render_template :best_answer
      end
    end

    context 'other user' do
      let(:user) { answer.user }
      before { login(user) }

      it 'not changes answer best status' do
        patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js
        question.reload
        answer.reload
        expect(answer.best?).to eq false
      end

      it 'leaves same answers number as was' do
        expect { patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js }
            .to not_change(Answer, :count)
            .and not_change(Question, :count)
      end

      it 'redirects to view page' do
        patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
      end

      it 'returns forbidden http status code' do
        patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js
        expect(response).to have_http_status(403)
      end
    end

    context 'visitor' do
      it 'not changes answer attributes' do
        patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js
        question.reload
        answer.reload
        expect(answer.best?).to eq false
      end

      it 'leaves same answers number as was' do
        expect { patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js }
            .to not_change(Answer, :count)
            .and not_change(Question, :count)
      end

      it 'renders update template' do
        patch :best_answer, params: { id: question.id, question: { best_answer_id: answer.id } }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end
  #
  # ============

  describe 'POST #delete' do
    let(:owner) { create(:user) }
    let!(:question) { create(:question, user: owner) }

    context 'can delete his own questions' do
      before { login(owner) }

      it 'keeps questions number same' do
        expect { delete :destroy, params: { id: question.id } }
          .to change(Question, :count).by(-1)
      end

      it 'redirects to view page' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to questions_path
      end
    end

    context "can't delete others questions" do
      let(:user) { create(:user) }
      before { login(user) }

      it 'keeps questions number same' do
        expect { delete :destroy, params: { id: question.id } }
          .to_not change(Question, :count)
      end

      it 'redirects to view page' do
        delete :destroy, params: { id: question.id }
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
      end

      it 'returns forbidden http status code' do
        delete :destroy, params: { id: question.id }
        expect(response).to have_http_status(403)
      end
    end

    context "visitor can't edit questions" do
      it 'keeps questions number same' do
        expect { delete :destroy, params: { id: question.id } }
          .to_not change(Question, :count)
      end

      it 'redirects to view page' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
