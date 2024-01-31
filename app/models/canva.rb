# frozen_string_literal: true

class Canva < ApplicationRecord
  has_one_attached :image

  belongs_to :user_profile, class_name: 'UserProfile', foreign_key: 'user_profile_id'
  belongs_to :chapter, class_name: 'Chapter', foreign_key: 'chapter_id'

  has_many :likes, dependent: :destroy
  has_many :opinions, dependent: :destroy
  has_one :nft_asset, class_name: 'NftAsset', dependent: :destroy

  after_update :upload_to_ipfs, if: :activated_first_time?

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

  def user_gave_like(user)
    return false if user.blank?

    likes.find { |like| like.user_profile&.sub == user.sub }.present?
  end

  def active_chapter
    return unless saved_change_to_attribute?(:active) && active? && !chapter.active?

    chapter.update(active: true)
  end

  def activated_first_time?
    saved_change_to_active? && active? && nft_asset.nil?
  end
  
  def upload_to_ipfs
    ipfs_service = NftStorageService.new

    image_blob = image.blob
    temp_file = Tempfile.new([image_blob.filename.base, image_blob.filename.extension_with_delimiter], binmode: true)
    
    image_blob.download { |chunk| temp_file.write(chunk) }
    temp_file.rewind

    ipfs_image_response = ipfs_service.upload_to_ipfs(temp_file.path, :file)
    ipfs_image_cid = ipfs_image_response['value']['cid']

    temp_file.close
    temp_file.unlink

    nft_metadata = generate_nft_metadata(ipfs_image_cid)
    ipfs_metadata_response = ipfs_service.upload_to_ipfs(nft_metadata, :json)
    ipfs_metadata_cid = ipfs_metadata_response['value']['cid']

    begin
      nft_asset = NftAsset.create!(canva_id: id, ipfs_image_cid: ipfs_image_cid, ipfs_metadata_cid: ipfs_metadata_cid)
    rescue => e
      puts "Error creating NftAsset: #{e.message}"
    end
  end

  def generate_nft_metadata(image_cid)
    storiette = chapter.storiette
  
    {
      name: "Comic ##{id}",
      description: storiette.title,
      image: "ipfs://#{image_cid}",
      attributes: [
        { trait_type: "Creator", value: user_profile.name },
        { trait_type: "Chapter", value: chapter.title },
        { trait_type: "Creation Date", value: created_at.strftime("%d/%m/%Y") },
      ],
      # external_url: Add link when DNS is configured
    }
  end
  
end
