class NftAsset < ApplicationRecord
  belongs_to :canva
  has_many :nft_transactions, dependent: :destroy
  has_one :nft_ownership, dependent: :destroy

  validates :ipfs_image_cid, presence: true
end
