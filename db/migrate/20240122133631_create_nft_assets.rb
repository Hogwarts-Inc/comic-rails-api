class CreateNftAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :nft_assets do |t|
      t.references :canva, null: false, foreign_key: true
      t.string :ipfs_image_cid
      t.string :ipfs_metadata_cid
      t.timestamps
    end
  end
end
