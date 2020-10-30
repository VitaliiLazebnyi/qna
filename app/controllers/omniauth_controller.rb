# frozen_string_literal: true

class OmniauthController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_by_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'something went wrong'
    end
  end
end
