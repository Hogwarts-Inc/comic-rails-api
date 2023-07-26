# frozen_string_literal: true

class Chapter < ApplicationRecord
  belongs_to :storiette, class_name: 'Storiette', foreign_key: 'storiette_id'

  has_many :canvas, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id storiette_id title updated_at]
  end
end
