class TokenSession < ApplicationRecord
  belongs_to :user_profile, class_name: 'UserProfile', foreign_key: 'user_profile_id'

  validates_presence_of :token

  after_create :remove_user_session_after_token_expires

  def remove_user_session_after_token_expires
    RemoveUserSessionJob.perform_in(12.hours, id)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "token", "updated_at", "user_profile_id"]
  end
end
