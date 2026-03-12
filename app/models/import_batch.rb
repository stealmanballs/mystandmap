# frozen_string_literal: true

class ImportBatch < ApplicationRecord
  belongs_to :user, optional: true
  
  has_many :import_errors, dependent: :destroy
  
  validates :file_name, presence: true
  
  enum :status, { pending: 'pending', processing: 'processing', completed: 'completed', failed: 'failed' }, default: :pending
  
  def self.ransackable_attributes(auth_object = nil)
    %w[file_name status imported_count failed_count duplicate_count created_at]
  end
end
