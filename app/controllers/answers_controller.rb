class AnswersController < ApplicationController

  before_action :set_answer, only: %i[show]
  before_action :set_question, only: %i[new]

  def show; end

  def new
    @answer = @question.answers.new
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
