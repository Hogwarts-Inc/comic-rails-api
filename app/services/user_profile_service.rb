class UserProfileService

  def self.find_or_create(user_params)
    return nil if user_params.blank?

    user = UserProfile.find_by(sub: user_params['sub'])
    user = UserProfile.create(user_params) if user.blank?

    user
  end

  def self.find_user_by_session(token)
    user_session = TokenSession.find_by(token: token)

    return user_session.user_profile if token.present? && user_session.present?

    nil
  end
end
