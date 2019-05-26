# frozen_string_literal: true

class AnswersController < ApplicationController
  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to [question, @answer]
    else
      render :new
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
