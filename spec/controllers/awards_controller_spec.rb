# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  describe 'GET #index' do
    context 'as user' do
      let(:user) { create :user }
      before     { login(user) }

      it 'renders proper page' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'as visitor' do
      it 'renders proper page' do
        get :index
        expect(response).to have_http_status(302)
      end
    end
  end
end
