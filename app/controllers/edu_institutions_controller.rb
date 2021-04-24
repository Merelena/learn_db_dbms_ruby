class EduInstitutionsController < ApplicationController
  before_action :set_edu_institution, only: [:show, :update, :destroy]
  before_action :authenticate_user_from_token!
  before_action :isSuperadmin?

  # GET /edu_institutions
  def index
    @edu_institutions = EduInstitution.all
    render json: @edu_institutions
  end

  # GET /edu_institutions/1
  def show
    render json: @edu_institution
  end

  # POST /edu_institutions
  def create
    @edu_institution = EduInstitution.new(edu_institution_params)
    if @edu_institution.save
      render json: @edu_institution, status: :created
    else
      render json: @edu_institution.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /edu_institutions/1
  def update
    if @edu_institution.update(edu_institution_params)
      render json: @edu_institution
    else
      render json: @edu_institution.errors, status: :unprocessable_entity
    end
  end

  # DELETE /edu_institutions/1
  def destroy
    @edu_institution.destroy
    render json: {
      message: "Edu institution deleted" },
      status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edu_institution
      begin
        @edu_institution = EduInstitution&.find(params[:id])
      rescue
        render json: {
          exception: "No edu institution" },
          status: 200 unless @edu_institution
      end
    end

    # Only allow a list of trusted parameters through.
    def edu_institution_params
      params.require(:edu_institution).permit(:edu_institution, :city)
    end

    def isSuperadmin?
      if current_user.role != 'superadmin'
        render status: 403
      else
        true        
      end
    end
end
