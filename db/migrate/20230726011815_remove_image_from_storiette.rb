# frozen_string_literal: true

class RemoveImageFromStoriette < ActiveRecord::Migration[7.0]
  def change
    remove_column :storiettes, :image
  end
end
