# frozen_string_literal: true

class Canva < ApplicationRecord
  has_one_attached :image

  belongs_to :chapter, class_name: 'Chapter', foreign_key: 'chapter_id'

  validates_presence_of :image

  scope :active, -> { where(active: true) }

  after_save :active_chapter

  def self.ransackable_attributes(_auth_object = nil)
    %w[chapter_id created_at id title updated_at active]
  end

  def active_chapter
    return unless saved_change_to_attribute?(:active) && active? && !chapter.active?

    chapter.update(active: true)
  end
end
