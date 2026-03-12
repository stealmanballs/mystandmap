# frozen_string_literal: true

class CreateImportBatches < ActiveRecord::Migration[7.2]
  def change
    create_table :import_batches do |t|
      t.string :file_name
      t.string :status, default: 'pending'
      t.integer :imported_count, default: 0
      t.integer :failed_count, default: 0
      t.integer :duplicate_count, default: 0
      t.text :error_summary
      t.references :user, foreign_key: true
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
