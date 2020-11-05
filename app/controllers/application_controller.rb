# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :send_user_id_to_front, only: :show
  before_action :make_action_mailer_use_request_host_and_protocol

  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def send_user_id_to_front
    return unless current_user

    gon.user_id = current_user.id
  end
end
