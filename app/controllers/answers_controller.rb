class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_answer, only: %i[show destroy]
  before_action :set_question, only: %i[create]

  def show; end

  def new; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user&.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer was successfully deleted'
    else
      redirect_to question_path(@answer.question), notice: 'You are not the author of the answer.'
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end