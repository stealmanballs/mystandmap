# frozen_string_literal: true

class AddRoleIndexToUsers < ActiveRecord::Migration[7.2]
  def change
    add_index :users, :role
  end
end
