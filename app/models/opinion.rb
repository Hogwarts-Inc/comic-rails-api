class Opinion < ApplicationRecord
  belongs_to :user_profile, class_name: 'UserProfile', foreign_key: :user_profile_id
  belongs_to :canva, class_name: 'Canva', foreign_key: :canva_id

  validates_presence_of :text

  scope :active, -> { where(active: true) }

  def self.ransackable_attributes(auth_object = nil)
    ["active", "canva_id", "created_at", "id", "text", "updated_at", "user_profile_id"]
  end
end
