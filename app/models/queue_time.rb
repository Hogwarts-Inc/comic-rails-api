# frozen_string_literal: true

class QueueTime < ApplicationRecord
  scope :active, -> { where(active: true) }

  before_save :deactivate_previous_queue_time
  after_save :remove_users_from_queues

  validates_presence_of :remove_from_queue_time, message: "no puede estar vacio"
  validate :time_validations

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at active id updated_at]
  end

  def time_validations
    if self.remove_from_queue_time.present? && self.remove_from_queue_time < 1
      errors.add(:remove_from_queue_time, 'tiene que ser mayor a 1 minuto')
    end
  end

  def remove_users_from_queues
    # Remove all queues
    CanvasQueueService.remove_all_queues

    # Remove all schedule for removing people from queues
    CanvasQueueService.remove_all_schedule_by_job(
      'RemoveUserFromQueueJob'
    )
  end

  def deactivate_previous_queue_time
    return unless self.active? && self.active_changed?

    QueueTime.active.update_all(active: false)
  end
end
