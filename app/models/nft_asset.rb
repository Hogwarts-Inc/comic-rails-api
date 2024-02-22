class NftAsset < ApplicationRecord
  belongs_to :canva
  has_many :nft_transactions
  has_one :nft_ownership

  validates :ipfs_image_cid, presence: true
end
