# frozen_string_literal: true

class CreateStands < ActiveRecord::Migration[7.2]
  def change
    create_table :stands do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :stand_type
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.string :email
      t.string :website_url
      t.string :facebook_url
      t.string :google_maps_url
      t.text :hours_text
      t.text :products_text
      t.boolean :open_now_override
      t.boolean :verified
      t.boolean :claimed
      t.datetime :last_verified_at
      t.string :source

      t.timestamps
    end

    add_index :stands, :slug, unique: true
    add_index :stands, :city
    add_index :stands, :stand_type
    add_index :stands, :claimed
  end
end
