require 'redis'
require 'sidekiq/api'

class CanvasQueueService

  def self.redis
    @redis ||= Redis.new(Rails.application.config_for(:redis))
  end

  def self.user_in_queue?(chapter_id, user_sub)
    # Use Redis set to store the state of users in the queue
    redis_key = "canvas_queue_#{chapter_id}"

    redis.watch(redis_key) do
      if redis.scard(redis_key).positive?
        if redis.smembers(redis_key).first == user_sub
          :first_user_in_queue
        elsif redis.smembers(redis_key).include?(user_sub)
          :user_in_queue
        else
          :have_user
        end
      else
        :no_user
      end
    end
  end

  def self.user_position_in_queue(chapter_id, user_sub)
    redis_key = "canvas_queue_#{chapter_id}"

    redis.watch(redis_key) do
      position = redis.smembers(redis_key).index(user_sub)

      if position
        # Adding 1 to make the position human-readable (1-based index)
        position + 1
      else
        # If the user is not in the queue
        nil
      end
    end
  end

  # Example:
  # job_name = 'RemoveUserFromQueueJob'
  # arguments_to_match = [chapter_id, user_sub]
  def self.remove_schedule_by_job_and_arguments(job_name, arguments_to_match)
    schedules = Sidekiq::ScheduledSet.new

    schedules.each do |job|
      if job.klass == job_name && job.args == arguments_to_match
        job.delete
        break
      end
    end
  end

    # Example:
  # job_name = 'RemoveUserFromQueueJob'
  # arguments_to_match = [chapter_id, user_sub]
  def self.remove_all_schedule_by_job(job_name)
    schedules = Sidekiq::ScheduledSet.new

    schedules.each do |job|
      if job.klass == job_name
        job.delete
        break
      end
    end
  end

  def self.remove_all_queues
    queue_keys = redis.keys("canvas_queue_*")

    redis.del(*queue_keys) unless queue_keys.empty?
  end

  def self.first_user_in_queue(chapter_id)
    redis_key = "canvas_queue_#{chapter_id}"

    redis.watch(redis_key) do
      redis.smembers(redis_key).first
    end
  end

  def self.queue_size(chapter_id)
    redis_key = "canvas_queue_#{chapter_id}"

    redis.watch(redis_key) do
      redis.smembers(redis_key).count
    end
  end

  def self.add_user_to_queue(chapter_id, user_sub)
    redis.multi do
      redis_key = "canvas_queue_#{chapter_id}"
      redis.sadd(redis_key, user_sub)
    end
  end

  def self.remove_user_from_queue(chapter_id, user_sub)
    # Remove the user from the $redis set representing the queue
    redis.multi do
      redis_key = "canvas_queue_#{chapter_id}"
      redis.srem(redis_key, user_sub)
    end
  end
end
