require 'open-uri'

class EduAidsController < ApplicationController
  before_action :set_edu_aid, only: [:show, :update, :destroy]
  before_action :authenticate_user_from_token!, except: [:index, :show]
  before_action :deserve?, except: [:index, :show]

  # GET /edu_aids
  def index
    @page = params[:p] || 1
    @edu_aids = EduAid.all
    @edu_aids = @edu_aids.where("lower(#{params[:field]}) like ?", "%#{params[:search].downcase}%") if params[:search]
    @edu_aids = @edu_aids.order("#{params[:field]} #{params[:sort]}") if params[:sort]    
    render json:  {
      type: "success",
      pages_count: EduAid.pgcount, 
      message: @edu_aids.page(@page)
    }
  end

  # GET /edu_aids/1
  def show
    render json: {
      type: "success",
      message: @edu_aid
    }
  end

  # POST /edu_aids
  def create    
    unless edu_aid_params[:document]
      render json: {
        type: "error",
        message: "Document file is mandatory"
        }, status: :unprocessable_entity
      return
    end
    @edu_aid = EduAid.new(edu_aid_params)

    if @edu_aid.save
      render json: {
        type: "success",
        message: @edu_aid
        }, status: :created, location: @edu_aid
    else
      render json:  {
        type: "error",
        message: @edu_aid.errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /edu_aids/1
  def update
    if @edu_aid.update(edu_aid_params)
      render json: {
        type: "success",
        message: @edu_aid
      }
    else
      render json: {
        type: "error",
        message: @edu_aid.errors 
      }, status: :unprocessable_entity
    end
  end

  # DELETE /edu_aids/1
  def destroy
    @edu_aid.remove_image!    
    @edu_aid.remove_document!
    FileUtils.remove_dir(Rails.root + "public/documents/#{@edu_aid.id}", true)
    FileUtils.remove_dir(Rails.root + "public/images/#{@edu_aid.id}", true)
    @edu_aid.save!
    @edu_aid.destroy!
    render json: {
      response: "Edu aid deleted"
    }, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edu_aid
      begin
        @edu_aid = EduAid.find(params[:id])
      rescue
        render json: {
          response: "No edu aid"
        }, status: 200 unless @edu_aid
      end
    end

    # Only allow a list of trusted parameters through.
    def edu_aid_params
      params[:user_id] = current_user.id
      result = params.permit(
        :name,
        :authors,
        :image,
        :document,
        :number_of_pages,
        :description,
        :publisher,
        :publish_year,
        :user_id
      )
      result
    end

    def deserve?
      if !['lector', 'admin', 'superadmin'].include?(current_user.role) 
        render json: { type: "error" }, status: 403
      else
        true        
      end
    end
end
