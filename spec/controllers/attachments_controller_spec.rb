# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:author) { create :user }
    let(:user)   { create :user }
    let!(:question) { create :question, :with_file, user: author }
    let!(:attachment) { question.files.first }
    context 'author removes his attachment' do
      before { login(author) }

      it 'attachment removed from database' do
        expect { delete :destroy, params: { id: attachment.id }, format: :js }
          .to change(ActiveStorage::Attachment, :count).by(-1)
                                                       .and not_change(Question, :count)
      end

      it 'redirects to proper page' do
        delete :destroy, params: { id: attachment.id }, format: :js
        expect(response).to redirect_to attachment_path(attachment)
      end
    end

    context "user can't remove others attachments" do
      before { login(user) }

      it 'attachment removed from database' do
        expect { delete :destroy, params: { id: attachment.id }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'redirects to proper page' do
        delete :destroy, params: { id: attachment.id }, format: :js
        expect(response).to render_template(file: "#{Rails.root}/public/403.html")
      end

      it 'returns forbidden http status code' do
        delete :destroy, params: { id: attachment.id }, format: :js
        expect(response).to have_http_status(403)
      end
    end

    context "visitor can't remove any attachments" do
      it 'not changes attachments number' do
        expect { delete :destroy, params: { id: attachment.id }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'proper error message' do
        delete :destroy, params: { id: attachment.id }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end

      it 'returns redirect http status code' do
        delete :destroy, params: { id: attachment.id }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
