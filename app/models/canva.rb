# frozen_string_literal: true

class Canva < ApplicationRecord
  has_one_attached :image

  belongs_to :user_profile, class_name: 'UserProfile', foreign_key: 'user_profile_id'
  belongs_to :chapter, class_name: 'Chapter', foreign_key: 'chapter_id'

  has_many :likes, dependent: :destroy
  has_many :opinions, dependent: :destroy

  validates_presence_of :image

  scope :active, -> { where(active: true) }
  default_scope { order("created_at ASC") }

  after_save :active_chapter


  def self.ransackable_attributes(auth_object = nil)
    ["active", "chapter_id", "created_at", "id", "title", "updated_at", "user_profile_id"]
  end

  def likes_count
    likes.count
  end

  def active_chapter
    return unless saved_change_to_attribute?(:active) && active? && !chapter.active?

    chapter.update(active: true)
  end
end
