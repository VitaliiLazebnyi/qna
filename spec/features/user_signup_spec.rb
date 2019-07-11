# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', '
  In order to login
  User wants to sign up
' do
  given(:user) { FactoryBot.build(:user) }

  background { visit new_user_registration_path }

  scenario 'user tries to sign up with correctly filled form' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'user tries to sign up but confirmed his password incorrectly' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: 'wrong_password'

    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
