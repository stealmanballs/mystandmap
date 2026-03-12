# frozen_string_literal: true

class Stand < ApplicationRecord
  # Geocoding
  geocoded_by :full_address
  after_validation :geocode, if: -> { address_changed? && latitude.nil? && longitude.nil? }
  
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
  
  # Check if address fields changed for geocoding
  def address_changed?
    saved_change_to_address_1? || saved_change_to_address_2? || 
    saved_change_to_city? || saved_change_to_state? || saved_change_to_zip?
  end
  
  # Clear cache when stand is updated
  after_save :clear_cache
  after_destroy :clear_cache
  
  def clear_cache
    Rails.cache.delete("stand_#{id}_#{updated_at.to_i}")
    # Clear the stands list cache (all variations)
    Rails.cache.delete_matched("stands_list_*")
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
