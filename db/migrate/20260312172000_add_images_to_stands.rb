# frozen_string_literal: true

class AddImagesToStands < ActiveRecord::Migration[7.2]
  def change
    add_column :stands, :images, :jsonb, default: []
  end
end
