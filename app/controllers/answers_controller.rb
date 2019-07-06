# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find(params[:question_id])
    @answer  = question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
      redirect_to question, notice: 'Your answer was successfully created.'
    else
      redirect_to question, notice: "Error: answer can't be empty."
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    check_user_permissions

    if @answer.destroy
      redirect_to @answer.question, notice: 'Your answer was successfully removed.'
    else
      redirect_to @answer.question, notice: "Error: answer can't be removed."
    end
  end

  private

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
