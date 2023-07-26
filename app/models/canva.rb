# frozen_string_literal: true

class Canva < ApplicationRecord
  has_one_attached :image

  belongs_to :chapter, class_name: 'Chapter', foreign_key: 'chapter_id'

  # validates :image, presence: true

  def imageUrl
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
