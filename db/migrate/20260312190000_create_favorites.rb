# frozen_string_literal: true

class CreateFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stand, null: false, foreign_key: true
      t.timestamps
    end
    
    add_index :favorites, [:user_id, :stand_id], unique: true
  end
end
