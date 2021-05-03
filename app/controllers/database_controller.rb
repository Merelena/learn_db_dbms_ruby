class DatabaseController < ApplicationController
  def request
    #@requests = params[:request].split(";")
    response = User.find_by_sql("select * from edu_institutions")
    render json: {exctention: response.to_s}, status: 200      
  end

  private
end
