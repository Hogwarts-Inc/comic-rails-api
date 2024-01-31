class AddUserToQueueJob
  include Sidekiq::Job

  def perform(chapter_id, user_sub)
    CanvasQueueService.add_user_to_queue(chapter_id, user_sub)
  end
end
