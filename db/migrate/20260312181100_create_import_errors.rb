# frozen_string_literal: true

class CreateImportErrors < ActiveRecord::Migration[7.2]
  def change
    create_table :import_errors do |t|
      t.references :import_batch, null: false, foreign_key: true
      t.integer :row_number
      t.text :row_data
      t.text :error_message
      t.string :error_type

      t.timestamps
    end
  end
end
