class Character < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :descriptions, dependent: :destroy, as: :descriptionable
  has_many_attached :images

  validates_presence_of :name, :images

  def merge_image_and_description
    as_json.merge({
      images_urls: images.map { |image| url_for(image) },
      descriptions: descriptions.map { |description| description.slice(
        :id, :title, :text, :active
      )}
    })
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ['descriptions', 'images_attachments', 'images_blobs']
  end
end
