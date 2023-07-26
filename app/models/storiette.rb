# frozen_string_literal: true

class Storiette < ApplicationRecord
  has_many :chapters, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id title updated_at]
  end
end
