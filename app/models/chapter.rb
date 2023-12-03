# frozen_string_literal: true

class Chapter < ApplicationRecord
  belongs_to :storiette, class_name: 'Storiette', foreign_key: 'storiette_id'

  has_many :canvas, dependent: :destroy

  scope :active, -> { where(active: true) }

  after_save :deactivate_canvas

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id storiette_id title updated_at active]
  end

  def total_likes_count
    canvas.map(&:likes_count).sum
  end

  def deactivate_canvas
    return unless saved_change_to_attribute?(:active) && !active?

    canvas.active.update_all(active: false)
  end
end
