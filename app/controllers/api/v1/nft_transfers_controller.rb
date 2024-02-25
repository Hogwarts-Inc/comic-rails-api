module Api
  module V1
    class NftTransfersController < ApplicationController
      before_action :authorize
      before_action :set_nft_asset, only: [:create]

      # POST /nft_transfers
      def create
        nft_transaction = NftTransaction.new(nft_transaction_params)
        nft_transaction.nft_asset_id = @nft_asset.id
        nft_transaction.transaction_type = 'transferring'

        if nft_transaction.save
          update_nft_ownership(nft_transaction)
          render json: nft_transaction, status: :created
        else
          render json: nft_transaction.errors, status: :unprocessable_entity
        end
      end
      
      private
      
      def set_nft_asset
        token_id = params.dig(:nft_transfer, :token_id)
        @nft_asset = NftAsset.find_by(token_id: token_id)
        
        unless @nft_asset
          render json: { error: 'NFT asset not found' }, status: :not_found
          return
        end
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def nft_transaction_params
        params.require(:nft_transfer).permit(:from_address, :to_address, :transaction_hash)
      end

      def update_nft_ownership(nft_transaction)
        ownership = NftOwnership.find_or_initialize_by(nft_asset_id: nft_transaction.nft_asset_id)
        
        ownership.update(
          owner_address: nft_transaction.to_address,
          acquired_at: Time.current 
        )
      end
    end
  end
end
