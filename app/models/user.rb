class User < ApplicationRecord
  has_secure_password
  
  enum :role, { user: 'user', farmer: 'farmer', admin: 'admin' }, default: :user
  
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_digest_changed?
  
  has_many :claims, dependent: :destroy
  has_many :stands, through: :claims, source: :stand do
    def approved
      where("claims.status = 'approved'")
    end
  end
  
  # Password reset
  def generate_password_reset_token
    update!(
      reset_password_token: SecureRandom.urlsafe_base64(48),
      reset_password_sent_at: Time.current
    )
    reset_password_token
  end
  
  def password_reset_valid?
    reset_password_sent_at && reset_password_sent_at > 2.hours.ago
  end
  
  def clear_password_reset_token!
    update!(reset_password_token: nil, reset_password_sent_at: nil)
  end
  
  def admin?
    role == 'admin'
  end
  
  def farmer?
    role == 'farmer'
  end

  def valid_password?(password)
    authenticate(password)
  end
end
