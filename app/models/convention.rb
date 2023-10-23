class Convention < ApplicationRecord
  has_many :descriptions, dependent: :destroy, as: :descriptionable

  has_one_attached :image

  validates_presence_of :name, :image

  scope :active, -> { where(active: true) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name active updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ['descriptions', 'image_attachment', 'image_blob']
  end
end
