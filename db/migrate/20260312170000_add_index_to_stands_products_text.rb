# frozen_string_literal: true

class AddIndexToStandsProductsText < ActiveRecord::Migration[7.2]
  def change
    add_index :stands, :products_text
  end
end
