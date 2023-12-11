require 'sidekiq'
require 'redis'

redis_url = if ENV['RAILS_ENV'] == 'production'
  ENV['REDIS_URL']
else
  'redis://localhost:6379/0'
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
