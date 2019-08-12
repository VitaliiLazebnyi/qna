require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_presence_of(:title) }

  it { should belong_to(:linkable) }

  context '.url format validation' do
    it 'allows proper urls' do
      link = build :link, url: 'http://www.google.com'
      link.validate
      expect(link.errors[:url]).to be_blank
    end

    it 'generates errors for no url' do
      link = build :link, url: nil
      link.validate
      expect(link.errors[:url]).to be_present
    end

    it 'generates errors for invalid url' do
      link = build :link, url: 'www'
      link.validate
      expect(link.errors[:url]).to be_present
    end
  end
end
