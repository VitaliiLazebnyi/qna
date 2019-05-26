# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :acceptance do
  scenario 'User can login' do
    User.create!(email: 'cm0k@mail.com', password: 666666)

    visit '/users/sign_in'
    fill_in :email, with: 'cm0k@mail.com'
    fill_in :password, with: 666666

    expect(page).to have_content "Successfully logged-in"
  end
  scenario 'User can log-out'
  scenario 'User can signup'
end
