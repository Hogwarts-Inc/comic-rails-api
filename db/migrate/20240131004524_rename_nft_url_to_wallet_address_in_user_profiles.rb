class RenameNftUrlToWalletAddressInUserProfiles < ActiveRecord::Migration[7.0]
  def change
    rename_column :user_profiles, :nft_url, :wallet_address
  end
end
