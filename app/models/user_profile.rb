class UserProfile < ApplicationRecord
  has_one_attached :image

  has_many :canvas, dependent: :nullify

  validates :given_name, :family_name, :sub, presence: true
  validates_uniqueness_of :sub, message: 'must be unique'

  before_save :add_name

  def add_name
    self.name = "#{given_name} #{family_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ['created_at', 'email', 'picture', 'given_name', 'id', 'family_name', 'sub', 'nft_url', 'updated_at']
  end
end
