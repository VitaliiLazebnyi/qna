# frozen_string_literal: true

module FeatureHelpers
  def login(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end

RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    page.body.index(earlier_content) < page.body.index(later_content)
  rescue ArgumentError
    raise "Could not locate later content on page: #{later_content}"
  rescue NoMethodError
    raise "Could not locate earlier content on page: #{earlier_content}"
  end
end

RSpec::Matchers.define_negated_matcher :not_change, :change
