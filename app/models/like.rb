class Like < ApplicationRecord
  belongs_to :user_profile, class_name: 'UserProfile', foreign_key: :user_profile_id
  belongs_to :canva, class_name: 'Canva', foreign_key: :canva_id

  def self.ransackable_attributes(auth_object = nil)
    ["canva_id", "created_at", "id", "updated_at", "user_profile_id"]
  end
end
