class GraphicResource < ApplicationRecord
  has_one_attached :image

  enum resource_type: { character: 0, background: 1, object: 2, dialog: 3 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[resource_type]
  end
end
