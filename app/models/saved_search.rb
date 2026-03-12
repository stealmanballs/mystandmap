# frozen_string_literal: true

class SavedSearch < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true
  validates :user_id, uniqueness: { scope: :name }
  
  # Search criteria stored as JSON
  serialize :criteria, coder: JSON
  
  # Alert settings
  enum :alert_frequency, { instant: 'instant', daily: 'daily', weekly: 'weekly', never: 'never' }, default: :never
  
  # Validates criteria has required fields
  validate :valid_criteria
  
  def criteria_defaults
    {
      radius: 25,
      lat: 43.7844,
      lng: -88.7879,
      location: '',
      filter: ''
    }
  end
  
  def criteria_with_defaults
    criteria_defaults.merge(criteria || {})
  end
  
  def search_params
    c = criteria_with_defaults
    {
      radius: c[:radius],
      lat: c[:lat],
      lng: c[:lng],
      filter: c[:filter]
    }
  end
  
  private
  
  def valid_criteria
    return if criteria.is_a?(Hash)
    errors.add(:criteria, "must be a valid search criteria")
  end
end
