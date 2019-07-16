# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer,            only: %i[update destroy]
  before_action :check_user_permissions, only: %i[update destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer   = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def check_user_permissions
    return if current_user.author_of?(@answer)

    render file: File.join(Rails.root, 'public/403.html'),
           status: :forbidden,
           layout: false
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
