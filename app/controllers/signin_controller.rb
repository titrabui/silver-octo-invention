class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user  = User.find_by!(email: params[:email])

    if user.authenticate(params[:password])
      payload = { user_id: user.id, aud: [user.role] }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      token = session.login
      response.set_cookie(JWTSessions.access_cookie,
                          value: token[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      
      render json: { csrf: token[:csrf] }
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end

  private

  def not_found
    render json: { error: 'Cannont find such email/password combination' }, status: :not_found
  end
end
