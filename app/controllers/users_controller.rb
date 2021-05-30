class UsersController < ApplicationController
  before_action :authenticate_user_from_token!, :except => [:login]
  before_action :deserve?, :except => [:login, :logout, :show]


  # POST /users
  def create
    user_params = params.require('user').permit(
      :first_name,
      :last_name,
      :role,
      :email,
      :password,
      :edu_institution
    )
    if current_user&.role == 'superadmin'
      user_params[:edu_institution_id] = EduInstitution.where("edu_institution = '#{user_params[:edu_institution]}'")&.first&.id
    else
      if user_params[:role] == 'superadmin'
        render json: { type: "error" }, status: 403
        return
      end
      user_params[:edu_institution_id] = current_user.edu_institution_id
    end    
    user = User.new user_params.except(:edu_institution)
    if user[:edu_institution_id] && user.save!
          render json: {
            type: "success",
            response: "User created"
          }, status: :created
    else
          render json: {
            type: "error",
            response: "User creating failed"
          }, status: :unprocessable_entity
    end
  end

  # POST /users/:id
  def update
    user_params = params.require('user').permit(
      :id,
      :first_name,
      :last_name,
      :middle_name,
      :role,
      :email,
      :encrypred_password,
      :edu_institution
    )
    user = User.find(params[:id])
    if current_user&.role == 'superadmin'
      user_params[:edu_institution_id] = EduInstitution.where("edu_institution = '#{user_params[:edu_institution]}'")&.first&.id
    else
      if user_params[:role] == 'superadmin'
        render json: { type: "error" }, status: 403
        return
      end
      user_params[:edu_institution_id] = current_user.edu_institution_id
    end
    if user.update(user_params.except("edu_institution") )
      render json: {
        type: "success",
        response: user
      }
    else
      render json: {
        type: "error",
        response: user.errors
      }, status: :unprocessable_entity
    end
  end

  # GET /users/delete/:id
  def delete
    user = User.find(params[:id])
    # Only superadmin can delete users from all edu instituts
    if (user.edu_institution_d == current_user.edu_institutiontion_id || current_user.role == 'superadmin') && user.delete
      render json: {
        type: "success",
        response: "User deleted" 
      }, status: 200
    else
      render json: {
        type: "error",
        response: "No user" 
      }, status: 200
    end
  end

  # GET /users
  def index
    users = current_user&.role == 'superadmin' ? User.all : User.where("edu_institution_id = '#{current_user[:edu_institution_id]}'")
    users = users.where("lower(#{params[:field]}) like ?", "%#{params[:search].downcase}%") if params[:search]
    users = users.order("#{params[:field]} #{params[:sort]}") if params[:sort]
    render json: {
      type: "success",
      response: users
    }, status: 200
  end

  # GET /users/:id
  def show
    user = User.find(params[:id])
    if user.edu_institution_id == current_user.edu_institution_id || current_user.role == 'superadmin'
      render json: {
        type: "success",
        response:  user
      }, status: 200
    else
      render json: { type: "error" }, status: 403
    end
  end

  # POST /users/login
  def login
    user = User.where("email = '#{params[:email].split(/\s+/).first}'").first
    if user&.valid_password?(params[:password].split(/\s+/).first)
      user.save!
      render json: {
        "type": "success",
        "response": {
          "user": user,
          "token": user.authentication_token
        }
      }, status: :created
    else
      head(:unauthorized)
    end
  end

  # GET /users/logout
  def logout
    User.update(current_user.id, authentication_token: nil)
    render json: {
      type: "success",
      response: "Logged out"
    }, status: 200
  end

  private
    def deserve?
      if !['admin', 'superadmin'].include?(current_user&.role) 
        render json: { type: "error" }, status: 403
      else
        true        
      end
    end
end
