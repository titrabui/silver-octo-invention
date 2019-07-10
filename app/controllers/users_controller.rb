class UsersController < ApplicationController
  before_action :authorize_access_request!

  def me
    render json: current_user
  end

  # PATCH/PUT /users/1
  def upload
    if current_user.update(avatar: params[:file])
      render json: {
        id: current_user.id,
        email: current_user.email,
        role: current_user.role,
        avatar_url: (current_user.avatar.url && "http://#{request.host}:#{request.port}#{current_user.avatar.url}") || nil
      }
    else
      render json: current_user.errors, status: unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:full_name, :age, :address)
  end
end
