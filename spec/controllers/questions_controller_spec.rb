require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe "POST #create" do
    context "with valid parameters" do
      let(:question) { FactoryBot.attributes_for(:question) }

      it "saves new question to database" do
        expect { post :create, { params: { question: question } } }.
            to change(Question, :count).by(1)
      end

      it "redirects to view page" do
        post :create, { params: { question: question } }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid parameters" do
      let(:question) { FactoryBot.attributes_for(:question, title: nil, body: nil) }

      it "saves new question to database" do
        expect { post :create, { params: { question: question } } }.
            to_not change(Question, :count)
      end

      it "displays new template" do
        post :create, { params: { question: question } }
        expect(response).to render_template :new
      end
    end
  end
end
