# frozen_string_literal: true

class Stand < ApplicationRecord
  has_many :claims, dependent: :destroy
  has_many_attached :photos
  
  validates :name, presence: true
  validates :photos, limit: { max: 5 }
  validate :acceptable_photo
  
  before_validation :generate_slug
  
  def generate_slug
    self.slug ||= name.to_s.parameterize if name.present?
  end

  def acceptable_photo
    return unless photos.attached?

    max_size = 5.megabytes
    allowed_types = ['image/jpeg', 'image/png', 'image/webp', 'image/gif']

    photos.each do |photo|
      if photo.blob.byte_size > max_size
        errors.add(:photos, "is too large. Maximum size is 5MB per image.")
      end
      unless allowed_types.include?(photo.blob.content_type)
        errors.add(:photos, "must be a JPEG, PNG, WebP, or GIF image.")
      end
    end
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
  
  def self.ransackable_associations(auth_object = nil)
    []
  end
  
  def self.ransackable_scopes(auth_object = nil)
    []
  end
end
