class NftAsset < ApplicationRecord
  belongs_to :canva

  validates :ipfs_image_cid, presence: true
  validates :ipfs_metadata_cid, presence: true
end
