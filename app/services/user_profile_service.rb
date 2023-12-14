class UserProfileService

  def self.find_or_create(user_params)
    return nil if user_params.blank?

    user = UserProfile.find_by(sub: user_params['sub'])
    user = UserProfile.create(user_params) if user.blank?

    user
  end
end
