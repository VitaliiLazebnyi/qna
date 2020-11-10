# frozen_string_literal: true

module DeviseOverride
  class ConfirmationsController < Devise::ConfirmationsController
    skip_authorization_check

    private

    def after_confirmation_path_for(_resource_name, resource)
      sign_in(resource)
      root_path
    end
  end
end
