class UsersController < ApplicationController
  before_action :authorize_access_request!

  def me
    render json: current_user
  end

  # PATCH/PUT /users/1
  def update
    if current_user.update(user_params)
      render json:current_user
    else
      render json: current_user.errors, status: unprocessable_entity
    end
  end

  # POST /upload
  def upload
    if current_user.update(avatar: params[:file])
      render json: current_user
    else
      render json: current_user.errors, status: unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:display_name, :about, :birthday, :content_visibility)
  end
end
