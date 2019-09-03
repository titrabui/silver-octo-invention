require 'oauth2'

class OauthController < ApplicationController
  module GoogleConfig
    GOOGLE_CLIENT_ID     = '496834929234-3m4qiabe2js95a50sil960d0oct2b3er.apps.googleusercontent.com'
    GOOGLE_CLIENT_SECRET = 'Hid0F9R4jvI6vTuxw35x2Qbq'
    GOOGLE_SCOPE         = 'profile email'
    GOOGLE_API_CALLBACK  = 'http://localhost:8080/auth/google_oauth2/callback'
    GOOGLE_API_USER_URL  = '/api/resource'
  end

  TOKEN_ALGORITHM = 'HS256'
  OAUTH_KEYS = [:auth_code, :provider].freeze

  def google
    # google_token = oauth_client.auth_code.get_token(params[:auth_code], redirect_uri: GoogleConfig::GOOGLE_API_CALLBACK)
    google_token = oauth_client.auth_code.authorize_url(:redirect_uri => 'http://localhost:8080/oauth2/callback')
    puts "AAAAAAAAAAAAAAAAAAAA#{google_token}"
    token = oauth_client.auth_code.get_token(params[:auth_code], :redirect_uri => 'http://localhost:8080/oauth2/callback')
    # google_user  = google_token.get(GoogleConfig::GOOGLE_API_USER_URL).parsed
    # puts "AAAAAAAAAAAAA#{google_user}"

  #   return head :unauthorized if google_user['hd'] != 'peek.com'

  #   render json: response_json(google_user), status: :ok
  # rescue OAuth2::Error => e
  #   render json: { error: JSON.parse(e.response.body) }, status: :unauthorized
  end 

  private

  def google_params
    params.require(:oauth)
  end

  def response_json(google_user)
    {
      token: {
        access_token: generate_token(google_user),
        expires_at:   token_expiration
      },
      user:  google_user
    }
  end

  def generate_token(google_user)
    JWT.encode(token_payload(google_user), Google::GOOGLE_CLIENT_SECRET, TOKEN_ALGORITHM)
  end

  def token_payload(google_user)
    now = Time.now.to_i
    {
      'iss' => 'SOME_ISS',
      'exp' => token_expiration,
      'nbf' => now - 60,     # available for use 1 minute before now
      'iat' => now,          # time issued
      'jti' => SecureRandom.uuid,
      'sub' => google_user['email']
    }.merge(google_user)
  end

  def token_expiration
    @token_expiration ||= Time.now.to_i + 86_400 # expires 1 day from now
  end

  def oauth_client
    @oauth_client ||= OAuth2::Client.new(
      GoogleConfig::GOOGLE_CLIENT_ID,
      GoogleConfig::GOOGLE_CLIENT_SECRET,
      :site   => 'http://localhost:8080'
    )
  end
end
