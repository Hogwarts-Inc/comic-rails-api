class RemoveUserFromQueueJob
  include Sidekiq::Job

  def perform(chapter_id, user_sub)
    CanvasQueueService.remove_user_from_queue(chapter_id, user_sub)

    next_user_sub = CanvasQueueService.first_user_in_queue(chapter_id)

    return unless next_user_sub.present?

    RemoveUserFromQueueJob.perform_in(15.minutes, chapter_id, next_user_sub)
  end
end
