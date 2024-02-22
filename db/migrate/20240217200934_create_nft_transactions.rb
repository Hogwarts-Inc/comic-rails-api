class CreateNftTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :nft_transactions do |t|
      t.bigint :nft_asset_id
      t.string :transaction_hash
      t.string :transaction_type, default: "minting"
      t.string :from_address
      t.string :to_address

      t.timestamps
    end
    add_index :nft_transactions, :nft_asset_id
    add_foreign_key :nft_transactions, :nft_assets, column: :nft_asset_id
  end
end
