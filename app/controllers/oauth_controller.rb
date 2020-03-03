require 'google/api_client/client_secrets'
require 'google/apis/oauth2_v2'
require 'google/apis/errors'

class OauthController < ApplicationController
  module GoogleOauthConfig
    SCOPE        = 'profile email'
    REDIRECT_URI = 'http://localhost:8080'
  end

  def google
    oauth_service = setup_service_authorization
    oauth_user = oauth_service.get_userinfo_v2
    user = User.from_oauth(oauth_user: oauth_user, provider: params[:provider])

    payload = { user_id: user.id, aud: [user.role] }
    session = JWTSessions::Session.new(payload: payload,
                                        refresh_by_access_allowed: true,
                                        namespace: "user_#{user.id}")
    token = session.login
    response.set_cookie(JWTSessions.access_cookie,
                        value: token[:access],
                        path: '/',
                        httponly: true,
                        secure: Rails.env.production?)

    render json: { csrf: token[:csrf] }
  rescue Signet::AuthorizationError => e
    render json: { error: JSON.parse(e.response.body) }, status: :unauthorized
  end 

  private

  def setup_service_authorization
    auth_client.code = params[:auth_code]
    auth_client.fetch_access_token!
    auth_client.client_secret = nil
    oauth2_v2_service.authorization = auth_client
    oauth2_v2_service
  end

  def auth_client
    return @auth_client if @auth_client.present?
    @auth_client = client_secrets.to_authorization
    @auth_client.update!(
      :scope        => GoogleOauthConfig::SCOPE,
      :redirect_uri => GoogleOauthConfig::REDIRECT_URI)
    @auth_client
  end

  # Load from file `client_secrets.json` on root path
  def client_secrets
    @client_secret ||= Google::APIClient::ClientSecrets.load
  end

  def oauth2_v2_service
    @oauth2_v2_service ||= Google::Apis::Oauth2V2::Oauth2Service.new
  end
end
