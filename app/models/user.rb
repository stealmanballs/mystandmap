class User < ApplicationRecord
  has_secure_password
  
  enum :role, { user: 'user', farmer: 'farmer', admin: 'admin' }, default: :user
  
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_digest_changed?
  
  has_many :claims, dependent: :destroy
  has_many :stands, through: :claims
  
  def admin?
    role == 'admin'
  end
  
  def farmer?
    role == 'farmer' || role == 'admin'
  end
  
  def valid_password?(password)
    authenticate(password)
  end
end
