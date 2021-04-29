class TestsController < ApplicationController
  before_action :authenticate_user_from_token!, except: [:index, :show]
  before_action :deserve?, except: [:index, :show]
  before_action :set_test, only: [:show, :update, :destroy]

  # GET /tests
  def index
    @tests = Test.joins("JOIN users ON tests.user_id = users.id").select("
      users.id,
      users.last_name, 
      users.first_name, 
      users.middle_name, 
      users.role,
      tests.*")
    @tests = @tests.where("lower(#{params[:field]}) like ?", "%#{params[:search].downcase}%") if params[:search]
    @tests = @tests.order("#{params[:field]} #{params[:sort]}") if params[:sort]
    render json: @tests
  end

  # GET /tests/1
  def show
    @result = {}    
    @result[:test] = {name: Test.find(params[:id]).name}
    @result[:questions] = []
    questions = Question.where("test_id = #{params[:id]}")
    questions.each do |q|
      responses = Response.where("question_id = #{q.id}").select("id, response, correct")
      @result[:questions] << {question: q.question, responses: responses}
    end
    render json: @result
  end

  # POST /tests
  def create
    error = false
    @test = Test.new(test_params)
    error = true unless @test.save
    question_params.each do |q|
      q[:test_id] = @test.id
      @question = Question.new(q.permit(:question, :test_id))
      error = true unless @question.save
      q[:responses].each do |r|
        r[:question_id] = @question.id
        @response = Response.new(r.permit(:question_id, :correct, :response))
        @error = true unless @response.save
      end
    end
    if error
      render json: {exctention: "Test didn't create"}, status: :unprocessable_entity      
    else
      render json: {message: "Test created"}, status: :created
    end
  end

  # PATCH/PUT /tests/1
  def update
    if @test.update(test_params)
      render json: @test
    else
      render json: @test.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tests/1
  def destroy
    @test.destroy
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
        render status: 403
      else
        true        
      end
    end
end
