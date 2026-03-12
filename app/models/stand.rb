# frozen_string_literal: true

class Stand < ApplicationRecord
  has_many :claims, dependent: :destroy
  
  validates :name, presence: true
  
  before_validation :generate_slug
  
  def generate_slug
    self.slug ||= name.to_s.parameterize if name.present?
  end
  
  def full_address
    [address_1, address_2, city, state, zip].compact.reject(&:empty?).join(', ')
  end
  
  def claimed?
    claimed || claims.where(status: 'approved').exists?
  end
  
  def self.ransackable_attributes(auth_object = nil)
    %w[name city state stand_type products_text]
  end
end
