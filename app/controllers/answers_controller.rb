# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
      redirect_to question, notice: 'Your answer was successfully created.'
    else
      redirect_to question, notice: "Error: answer can't be empty."
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if @answer.destroy
      redirect_to question, notice: 'Your answer was successfully removed.'
    else
      redirect_to question, notice: "Error: answer can't be removed."
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
