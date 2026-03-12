# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :stand
  
  validates :user_id, uniqueness: { scope: :stand_id }
  
  # Validates that the stand exists
  validate :stand_exists
  
  private
  
  def stand_exists
    errors.add(:stand_id, "must exist") unless Stand.exists?(stand_id)
  end
end
