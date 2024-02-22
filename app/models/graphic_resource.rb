class GraphicResource < ApplicationRecord
  has_one_attached :image

  validates_presence_of :image

  enum resource_type: { background: 0, object: 1, dialog: 2 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[resource_type]
  end
end
