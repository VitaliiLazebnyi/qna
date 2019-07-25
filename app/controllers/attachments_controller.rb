# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :load_model
  before_action :check_permissions

  def destroy
    @attachement_id = @attachment.id
    @attachment.destroy
  end

  private

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def load_model
    @model = @attachment.record_type.constantize.find(@attachment.record_id)
  end

  def check_permissions
    render_403 unless current_user.author_of?(@model)
  end

  def render_403
    render file: File.join(Rails.root, 'public/403.html'),
           status: :forbidden,
           layout: false
  end
end
