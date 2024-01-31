class UserProfile < ApplicationRecord
  has_one_attached :image

  has_many :canvas, dependent: :nullify

  validates :sub, presence: true
  validates_uniqueness_of :sub, message: 'must be unique'

  before_save :add_name

  def add_name
    return if self.name.present?

    self.name = "#{given_name} #{family_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ['created_at', 'email', 'picture', 'given_name', 'id', 'family_name', 'sub', 'wallet_address', 'updated_at']
  end
end
