class TestsController < ApplicationController
  before_action :authenticate_user_from_token!, except: [:index, :show]
  before_action :deserve?, except: [:index, :show]
  before_action :set_test, only: [:show, :update, :destroy]

  # GET /tests
  def index
    @page = params[:p] || 1
    @tests = Test.joins("JOIN users ON tests.user_id = users.id").select("
      users.id,
      users.last_name, 
      users.first_name, 
      users.middle_name, 
      users.role,
      tests.*")
    @tests = @tests.where("lower(#{params[:field]}) like ?", "%#{params[:search].downcase}%") if params[:search]
    @tests = @tests.order("#{params[:field]} #{params[:sort]}") if params[:sort]
    render json: {
      type: "success",
      pages_count: Test.pgcount, 
      tests: @tests.page(@page)
    }
  end

  # GET /tests/1
  def show
    result = {}
    result[:id] = params[:id]
    result[:test] = {name: Test.find(params[:id]).name}
    result[:questions] = []
    questions = Question.where("test_id = #{params[:id]}")
    questions.each do |q|
      responses = Response.where("question_id = #{q.id}").select("id, response, correct")
      result[:questions] << {id: q.id, question: q.question, responses: responses}
    end
    render json: {
      type: "success",
      response: result
    }
  end

  # POST /tests
  def create
    error = false
    @test = Test.new(test_params)
    error = true unless @test.save
    question_params.each do |q|
      q[:test_id] = @test.id
      question = Question.new(q.permit(:question, :test_id))
      error = true unless question.save
      q[:responses].each do |r|
        r[:question_id] = question.id
        response = Response.new(r.permit(:question_id, :correct, :response))
        error = true unless response.save
      end
    end
    if error
      render json: {
        type: "error",
        response: "Test didn't create"
      }, status: :unprocessable_entity      
    else
      render json: {
        type: "success",
        response: "Test created"
        }, status: :created
    end
  end

  # PATCH/PUT /tests/1
  def update
    error = false
    @test = Test.find(params[:id])
    error = true unless @test.save
    question_params.each do |q|
      question = Question.find(q[:id])
      if q[:delete]
        question.destroy!
      else
        error = true unless question.update(q.permit(:question))
        q[:responses].each do |r|
          response = Response.find(r[:id])
          error = true unless response.update(r.permit(:question_id, :correct, :response))
        end
      end
    end
    if error
      render json: {
        type: "error",
        response: "Test didn't update"
      }, status: :unprocessable_entity      
    else
      render json: {
        type: "success",
        message: "Test updated"
      }, status: 200
    end
  end

  # DELETE /tests/1
  def destroy
    @test.destroy!
    render json: {
      type: "success",
      response: "Test deleted" 
    }, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def test_params
      result = params.require(:test)
      result[:user_id] = current_user.id
      result.permit(:name, :user_id)
    end

    def question_params
      questions = params.require(:questions)
    end

    def deserve?
      if !['lector', 'admin', 'superadmin'].include?(current_user.role) 
        render json: { type: "error" }, status: 403
      else
        true        
      end
    end
end
