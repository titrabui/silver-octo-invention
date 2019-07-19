class Admin::UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:show, :update, :destroy]
  VIEW_ROLES = %w[admin manager].freeze
  EDIT_ROLES = %w[admin].freeze
  DELETE_ROLES = %w[admin].freeze

  def index
    @users = User.all

    results = @users.map do |user|
      {
        id: user.id,
        email: user.email,
        role: user.role,
        posts: user.posts.present? ? user.posts.length : 0,
        comments: user.comments.present? ? user.comments.length : 0,
        display_name: user.display_name,
        about: user.about,
        birthday: user.birthday,
        content_visibility: user.content_visibility,
        avatar: user.avatar,
        created_at: user.created_at
      }
    end

    render json: results
  end

  def show
    render json: @user
  end

  def update
    if current_user.id != @user.id
      @user.update!(user_params)
      JWTSessions::Session.new(namespace: "user_#{@user.id}").flush_namespaced_access_tokens
      render json: @user
    else
      render json: { error: 'Admin cannot modify their own role' }, status: :bad_request
    end
  end

  def destroy
    if current_user.id != @user.id
      @user.destroy
    else
      render json: { error: 'Admin cannot delete their own account' }, status: :bad_request
    end
  end

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def allowed_aud
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA#{action_name}"
    EDIT_ROLES if action_name == 'update'
    DELETE_ROLES if action_name == 'destroy'
    VIEW_ROLES
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
