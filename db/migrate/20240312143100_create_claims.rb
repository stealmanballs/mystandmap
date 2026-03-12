# frozen_string_literal: true

class CreateClaims < ActiveRecord::Migration[7.2]
  def change
    create_table :claims do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stand, null: false, foreign_key: true
      t.string :status, default: 'pending'
      t.text :notes

      t.timestamps
    end

    add_index :claims, [:user_id, :stand_id], unique: true
    add_index :claims, :status
  end
end
