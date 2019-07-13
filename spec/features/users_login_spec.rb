# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign-in', '
  In order to ask questions
  User wants to enter the system
' do
  given!(:user) { FactoryBot.create(:user) }

  background { visit new_user_session_path }

  scenario 'registered user can login' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'unregistered user tries to login' do
    fill_in 'Email', with: 'unregistered@user.com'
    fill_in 'Password', with: 'wrong_pass'

    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end
end
