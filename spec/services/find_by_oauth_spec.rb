# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::FindByOauth do
  subject { Services::FindByOauth.new(auth) }

  context 'user has authorization' do
    let(:user) { create :user }
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: 123_456
      )
    end

    it 'returns user' do
      user.authorizations.create(provider: 'facebook', uid: 123_456)
      service = Services::FindByOauth.new(auth)
      expect(service.call).to eq user
    end
  end

  context 'user has no authorization' do
    let!(:user) { create :user }
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: 123_456,
        info: { email: user.email }
      )
    end

    context 'user already exists' do
      it "doesn't create a new user" do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates new authorization for a user' do
        expect { subject.call }.to change(Authorization, :count).by(1)
      end

      it 'created authorization contains proper data' do
        user = subject.call
        authorization = user.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid.to_s
      end

      it 'returns user' do
        expect(subject.call).to eq user
      end
    end

    context "user doesn't exist" do
      let(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'facebook',
          uid: 123_456,
          info: { email: 'new.user@email.com' }
        )
      end

      it 'create a new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it "fills user's email" do
        expect(subject.call.email).to eq auth[:info][:email]
      end

      it 'creates new authorization for a user' do
        expect { subject.call }.to change(Authorization, :count).by(1)
      end

      it 'created authorization contains proper data' do
        user = subject.call
        authorization = user.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid.to_s
      end

      it 'returns user' do
        expect(subject.call.class).to eq User
      end
    end
  end
end
