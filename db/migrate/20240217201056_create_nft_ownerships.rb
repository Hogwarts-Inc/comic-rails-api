class CreateNftOwnerships < ActiveRecord::Migration[7.0]
  def change
    create_table :nft_ownerships do |t|
      t.bigint :nft_asset_id, null: false
      t.string :owner_address
      t.datetime :acquired_at
      t.timestamps
    end
    add_index :nft_ownerships, :nft_asset_id
    add_foreign_key :nft_ownerships, :nft_assets, column: :nft_asset_id
  end
end
