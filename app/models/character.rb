class Character < ApplicationRecord
  has_many :descriptions, dependent: :destroy, as: :descriptionable
  has_many_attached :images

  validates_presence_of :name, :images

  scope :active, -> { where(active: true) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name updated_at active]
  end

  def self.ransackable_associations(auth_object = nil)
    ['descriptions', 'images_attachments', 'images_blobs']
  end
end
