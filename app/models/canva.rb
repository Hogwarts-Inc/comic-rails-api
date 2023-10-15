# frozen_string_literal: true

class Canva < ApplicationRecord
  has_one_attached :image

  belongs_to :chapter, class_name: 'Chapter', foreign_key: 'chapter_id'

  validates_presence_of :image

  def self.ransackable_attributes(_auth_object = nil)
    %w[chapter_id created_at id title updated_at]
  end
end
