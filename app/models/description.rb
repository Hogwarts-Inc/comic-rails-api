class Description < ApplicationRecord
  belongs_to :descriptionable, polymorphic: true

  validates_presence_of :text

  scope :active, -> { where(active: true) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[descriptionable_id descriptionable_type created_at id title text updated_at active]
  end

  def self.ransackable_associations(auth_object = nil)
    ['descriptionable']
  end
end
