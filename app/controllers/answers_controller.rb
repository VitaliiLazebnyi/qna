# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: %i[update make_best destroy]
  before_action :check_answer_permissions, only: %i[update destroy]
  before_action :check_question_permissions, only: %i[make_best]

  def create
    @question = Question.find(params[:question_id])
    @answer   = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
  end

  def make_best
    @answer.make_best!
  end

  def destroy
    @answer.destroy
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def check_answer_permissions
    render_403 unless current_user.author_of?(@answer)
  end

  def check_question_permissions
    render_403 unless current_user.author_of?(parent_question)
  end

  def parent_question
    @parent_question ||= @answer.question
  end

  def render_403
    send_file File.join(Rails.root, 'public/403.html'),
              :type => 'text/html; charset=utf-8',
              :status => :forbidden
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id title url _destroy])
  end
end
