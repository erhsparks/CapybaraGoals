class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :session_token, presence: true
  validates :password, presence: true, length: { minimum: 6, allow_nil: true }
  validates :password_digest, presence: true

  attr_reader :password

  after_initialize :ensure_session_token

  def ensure_session_token
    self.session_token = SecureRandom.urlsafe_base64
    self.save

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
