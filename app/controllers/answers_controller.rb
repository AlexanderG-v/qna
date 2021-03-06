class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]
  before_action :set_answer, only: %i[show update destroy best_answer]
  before_action :set_question, only: %i[create]
  after_action :publish_answer, only: :create

  authorize_resource

  def show; end

  def new; end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    @question = @answer.question
    flash.now[:notice] = 'Answer was successfully deleted'
  end

  def best_answer
    @question = @answer.question
    @question.set_best_answer(@answer)

    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}",
      answer: @answer
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                          links_attributes: [:id, :name, :url, :_destroy])
  end
end
