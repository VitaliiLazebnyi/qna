# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, except: %i[index new create]
  before_action :check_user_permissions, except: %i[index new show create]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
    @question.award = Award.new
    @question.links.build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def show
    @answer = @question.answers.new
    @answer.links.build
  end

  def update
    @question.update(question_params)
  end

  def destroy
    if @question.destroy
      redirect_to questions_path, notice: 'Your question was successfully removed.'
    else
      redirect_to @question
    end
  end

  private

  def check_user_permissions
    return if current_user.author_of?(@question)

    render file: File.join(Rails.root, 'public/403.html'),
           status: :forbidden,
           layout: false
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question)
          .permit(:title, :body,
                  files: [],
                  links_attributes: %i[id title url _destroy],
                  award_attributes: %i[id title url user_id _destroy])
  end
end
