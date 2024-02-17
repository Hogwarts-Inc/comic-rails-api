require 'net/http'
require 'uri'
require 'json'

class NftMintingService
  MINTING_SERVICE_ENDPOINT = 'http://localhost:4000/mint'

  def self.mint_nft(wallet_address, metadata_uri)
    new(wallet_address, metadata_uri).mint
  end

  def initialize(wallet_address, metadata_uri)
    @wallet_address = wallet_address
    @metadata_uri = metadata_uri
  end

  def mint
    uri = URI(MINTING_SERVICE_ENDPOINT)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = { address: @wallet_address, URI: @metadata_uri }.to_json
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    parse_response(response)
  rescue => e
    puts "Error in minting NFT: #{e.message}"
    nil
  end

  private

  def parse_response(response)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      puts "Failed to mint NFT: #{response.body}"
      nil
    end
  end
end
