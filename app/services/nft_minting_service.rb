class NftMintingService
  MINTING_SERVICE_ENDPOINT = 'http://localhost:4000/mint'

  def self.mint_nft(canva_id, wallet_address, metadata_uri)
    new(canva_id, wallet_address, metadata_uri).mint
  end

  def initialize(canva_id, wallet_address, metadata_uri)
    @canva_id = canva_id
    @wallet_address = wallet_address
    @metadata_uri = metadata_uri
    @owner_address = ENV['OWNER_ADDRESS']
  end

  def mint
    uri = URI(MINTING_SERVICE_ENDPOINT)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = { 
      address: @wallet_address, 
      URI: @metadata_uri
    }.to_json
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    handle_response(parse_response(response))
  rescue => e
    Rails.logger.error "Error in minting NFT: #{e.message}"
    nil
  end

  private

  def parse_response(response)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to mint NFT: #{response.body}"
      nil
    end
  end

  def handle_response(response)
    if response && response["txn_hash"]
      nft_asset = NftAsset.find_by(canva_id: @canva_id)
      nft_asset.update!(token_id: response["token_id"]) if nft_asset

      NftTransaction.create!(
        nft_asset_id: nft_asset.id,
        transaction_hash: response["txn_hash"],
        transaction_type: 'minting',
        from_address: @owner_address,
        to_address: @wallet_address
      )

      NftOwnership.create!(
        nft_asset_id: nft_asset.id,
        owner_address: @wallet_address,
        acquired_at: Time.current
      )
    else
      Rails.logger.error "NFT minting failed or didn't return expected data"
    end
  end
end
