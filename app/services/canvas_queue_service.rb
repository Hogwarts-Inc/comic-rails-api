require 'redis'

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
          :same_user
        else
          :have_user
        end
      else
        :no_user
      end
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
