# frozen_string_literal: true

class CreateSavedSearches < ActiveRecord::Migration[7.2]
  def change
    create_table :saved_searches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.json :criteria
      t.string :alert_frequency, default: 'never'
      t.integer :last_result_count, default: 0
      t.datetime :last_sent_at
      t.datetime :last_checked_at
      t.timestamps
    end
    
    add_index :saved_searches, [:user_id, :name], unique: true
  end
end
