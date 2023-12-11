class RemoveCanvaFromQueueJob
  include Sidekiq::Job

  def perform(chapter_id, user_sub)
    CanvasQueueService.remove_user_from_queue(chapter_id, user_sub)
  end
end
