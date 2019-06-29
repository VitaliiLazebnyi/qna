# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign-in', '
  In order to ask questions
  User wants to enter the system
' do
  scenario 'registered user can login' do
    User.create!(email: 'cm0k@mail.com', password: 666_666)

    visit '/users/sign_in'
    fill_in :email, with: 'cm0k@mail.com'
    fill_in :password, with: 666_666

    expect(page).to have_content 'Successfully logged-in'
  end

  scenario 'unregistered user tries to login' do
  end
end

RSpec.describe 'Users', type: :features do
  scenario 'User can login' do
  end
  scenario 'User can log-out'
  scenario 'User can register'
end
