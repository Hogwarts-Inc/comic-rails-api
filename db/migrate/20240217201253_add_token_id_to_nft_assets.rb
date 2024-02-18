class AddTokenIdToNftAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :nft_assets, :token_id, :string
    add_index :nft_assets, :token_id, unique: true 
  end
end
