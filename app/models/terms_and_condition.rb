# frozen_string_literal: true

class TermsAndCondition < ApplicationRecord
  has_one_attached :file

  validates_presence_of :file

  scope :active, -> { where(active: true) }

  before_save :deactivate_previous_terms_and_conditions

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at active id updated_at]
  end

  def deactivate_previous_terms_and_conditions
    return unless self.active? && self.active_changed?

    TermsAndCondition.active.update_all(active: false)
  end
end
