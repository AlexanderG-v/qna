class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: %i[show]
  before_action :set_question, only: %i[index show]

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : @answer.question
  end
end
