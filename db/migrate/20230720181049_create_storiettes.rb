# frozen_string_literal: true

class CreateStoriettes < ActiveRecord::Migration[7.0]
  def change
    create_table :storiettes do |t|
      t.string :title
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
