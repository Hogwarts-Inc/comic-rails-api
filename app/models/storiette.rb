# frozen_string_literal: true

class Storiette < ApplicationRecord
  has_many :chapters, dependent: :destroy

  validates_presence_of :title

  scope :active, -> { where(active: true) }

  before_save :deactivate_previous_storiette

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description active id title updated_at]
  end

  def deactivate_previous_storiette
    return unless self.active?

    Storiette.active.update_all(active: false)
  end
end
