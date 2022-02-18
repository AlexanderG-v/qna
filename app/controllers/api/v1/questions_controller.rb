class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url id],
                                                    reward_attributes: %i[title image])
  end
end
