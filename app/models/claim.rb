# frozen_string_literal: true

class Claim < ApplicationRecord
  belongs_to :user
  belongs_to :stand
  
  enum :status, { pending: 'pending', approved: 'approved', rejected: 'rejected' }, default: :pending
  
  validates :user_id, uniqueness: { scope: :stand_id }
end
