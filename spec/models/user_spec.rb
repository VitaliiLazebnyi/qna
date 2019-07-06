# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  context 'author_of? method' do
    let(:user) { create :user }
    let(:unsaved_user) { User.new }
    let(:resource) { Struct.new(:user_id) }

    it "it's author" do
      expect(user.author_of?(resource.new(user.id))).to eq true
    end

    it 'it is not author' do
      expect(user.author_of?(resource.new('other_user_id'))).to eq false
    end

    it 'unexpected objects should return false' do
      expect(user.author_of?('Some string')).to eq false
    end

    it 'unsaved user should return false' do
      expect(unsaved_user.author_of?(resource.new(nil))).to eq false
    end
  end
end
