class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :password_digest, presence: true

  attr_reader :password

  after_initialize :ensure_session_token

  def self.find_by_credentials(params)
    possible_user = User.find_by_username(params[:username])

    return ["User not found"] unless possible_user

    if possible_user.is_password?(params[:password])
      possible_user
    else
      ["Incorrect password for username #{possible_user.username}"]
    end
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!

    self.session_token
  end

  def password=(password)
    @password = password

    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(test_password)
    digest = BCrypt::Password.new(self.password_digest)

    digest.is_password?(test_password)
  end
end
