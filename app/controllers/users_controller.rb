class UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:update]

  def me
    render json: current_user
  end

  # PATCH/PUT /users/1
  def update
    puts "AAAAAAAAAAAAAAA#{params[:file]}"
    uploader.store!(params[:file])
    # if @user.update!({  })
    #   render json: @user
    # else
    #   render json: @user.errors, status: unprocessable_entity
    # end
    render json: 'success'
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:post).permit(:file)
  end

  def uploader
    @uploader ||= AvatarUploader.new
  end
end
