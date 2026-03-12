# frozen_string_literal: true

class ImportError < ApplicationRecord
  belongs_to :import_batch
  
  validates :row_number, presence: true
  validates :error_message, presence: true
end
