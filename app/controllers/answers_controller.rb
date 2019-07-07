# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer,            only: :destroy
  before_action :check_user_permissions, only: :destroy

  def create
    @question = Question.find(params[:question_id])
    @answer   = @question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if @answer.destroy
      redirect_to @answer.question, notice: 'Your answer was successfully removed.'
    else
      redirect_to @answer.question, notice: "Error: answer can't be removed."
    end
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
