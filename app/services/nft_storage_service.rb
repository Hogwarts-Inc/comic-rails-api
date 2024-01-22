require 'net/http'
require 'uri'
require 'json'

class NftStorageService
  API_ENDPOINT = 'https://api.nft.storage/upload'

  def initialize
    @api_key = ENV['NFT_STORAGE_API_KEY']
  end

  def upload_to_ipfs(file_path)
    uri = URI.parse(API_ENDPOINT)
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{@api_key}"
  
    file = File.open(file_path)
    request.body = file.read
    request.content_type = mime_type(file_path)
  
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    ensure
      file.close
    end
  
    return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    
    raise "Failed to upload to IPFS: #{response.body}"
  end
  
  private
  
  def mime_type(file_path)
    MIME::Types.type_for(file_path).first.content_type
  end
  
end
