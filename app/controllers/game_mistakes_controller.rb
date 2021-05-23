class GameMistakesController < ApplicationController
  before_action :set_game_mistake, only: [:show, :update, :destroy]
  before_action :authenticate_user_from_token!, except: [:show]
  before_action :deserve?, except: [:index, :show]

  # GET /game_mistakes
  def index
    @game_mistakes = GameMistake.all
    render json: {
      type: "success",
      response: @game_mistakes
    }
  end

  # GET /game_mistakes/1
  def show
    render json: {
      type: "success",
      response: @game_mistake
    }
  end

  # POST /game_mistakes
  def create
    @game_mistake = GameMistake.new(game_mistake_params)
    if @game_mistake.save
      render json: {
        type: "success",
        response: @game_mistake
      }, status: :created
    else
      render json: {
        type: "error",
        response: @game_mistake.errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /game_mistakes/1
  def update
    if @game_mistake.update(game_mistake_params)
      render json: {
        type: "success",
        response: @game_mistake
      }
    else
      render json: {
        type: "error",
        response: @game_mistake.errors
      }, status: :unprocessable_entity
    end
  end

  # DELETE /game_mistakes/1
  def destroy
    @game_mistake.destroy
    render json: {
      type: "success",
      response: "Task deleted" 
    }, status: 200
  end

  private
    def set_game_mistake
      @game_mistake = params[:id] == "generate" ? GameMistake.all.sample(1) : GameMistake.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_mistake_params
      params.require(:tasks).permit(:incorrect_task, :correct_task)
    end

    def deserve?
      if !['lector', 'admin', 'superadmin'].include?(current_user.role) 
        render json: { type: "error" }, status: 403
      else
        true        
      end
    end
end
