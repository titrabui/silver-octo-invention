class User < ApplicationRecord
  include ActiveModel::Serializers::JSON

  has_secure_password
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  enum role: %i[user manager admin].freeze

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  mount_uploader :avatar, AvatarUploader

  def attributes
    { id: id, email: email, role: role, avatar: avatar, display_name: display_name, about: about, birthday: birthday, content_visibility: content_visibility }
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    self.reset_password_token_expires_at = 1.day.from_now
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save!
  end
end
