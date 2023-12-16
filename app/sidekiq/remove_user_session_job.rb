class RemoveUserSessionJob
  include Sidekiq::Job

  def perform(user_session_id)
    user_session = TokenSession.find_by_id(user_session_id)
    user_session.destroy unless user_session.nil?
  end
end
