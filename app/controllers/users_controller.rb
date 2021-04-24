class UsersController < ApplicationController
  before_action :authenticate_user_from_token!, :except => [:login, :create]
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
    if current_user.role == 'superadmin'
      user_params[:edu_institution_id] = EduInstitution.where("edu_institution = '#{user_params[:edu_institution]}'")&.first&.id
    else
      if user_params[:role] == 'superadmin'
        render status: 403
        return
      end
      user_params[:edu_institution_id] = current_user.edu_institution_id
    end    
    user = User.new user_params.except(:edu_institution)
    if user[:edu_institution_id] && user.save!
          render json: {
            message: "User created"},
            status: :created
    else
          render json: {
            message: "User creating failed"}, 
            status: :unprocessable_entity
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
      :password,
      :edu_institution
    )
    user = User.find(user_params[:id])
    if current_user.role == 'superadmin'
      user_params[:edu_institution_id] = EduInstitution.where("edu_institution = '#{user_params[:edu_institution]}'")&.first&.id
    else
      if user_params[:role] == 'superadmin'
        render status: 403
        return
      end
      user_params[:edu_institution_id] = current_user.edu_institution_id
    end
    if user.update(user_params.except("edu_institution") )
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # GET /users/delete/:id
  def delete
    user = User.find(params[:id])
    # Only superadmin can delete users from all edu instituts
    if (user.edu_institution_d == current_user.edu_institutiontion_id || current_user.role == 'superadmin') && user.delete
      render json: {
        message: "User deleted" },
        status: 200
    else
      render json: {
        exception: "No user" },
        status: 200
    end
  end

  # GET /users
  def index
    users = current_user.role == 'superadmin' ? User.all : User.where("edu_institution_id = '#{current_user[:edu_institution_id]}'")
    users = users.where("lower(#{params[:field]}) like ?", "%#{params[:search].downcase}%") if params[:search]
    users = users.order("#{params[:field]} #{params[:sort]}") if params[:sort]
    render json: {
      users: users },
      status: 200
  end

  # GET /users/:id
  def show
    user = User.find(params[:id])
    if user.edu_institution_id == current_user.edu_institution_id || current_user.role == 'superadmin'
      render json: {
        users:  user},
        status: 200
    else
      render status: 403
    end
  end

  # POST /users/login
  def login
    user = User.where("email = '#{params[:email]}'").first
    if user&.valid_password?(params[:password])
      user.save!
      render json: {
        "user": user,
        "token": user.authentication_token
      }, status: :created
    else
      head(:unauthorized)
    end
  end

  # GET /users/logout
  def logout
    User.update(current_user.id, authentication_token: nil)
    render json: {
      message: "Logged out"
    }, status: 200
  end

  private
    def deserve?
      if !['admin', 'superadmin'].include?(current_user.role) 
        render status: 403
      else
        true        
      end
    end
end
