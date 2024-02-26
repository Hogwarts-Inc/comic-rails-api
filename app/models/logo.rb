# frozen_string_literal: true

class Logo < ApplicationRecord
  has_one_attached :image

  validates_presence_of :image

  scope :active, -> { where(active: true) }

  before_save :deactivate_previous_logo

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at active id updated_at]
  end

  def deactivate_previous_logo
    return unless self.active? && self.active_changed?

    Logo.active.update_all(active: false)
  end
end
