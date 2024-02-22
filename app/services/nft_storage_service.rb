require 'net/http'
require 'uri'
require 'json'

class NftStorageService
  def initialize
    @api_key = ENV['NFT_STORAGE_API_KEY']
    @api_endpoint = ENV['NFT_STORAGE_ENDPOINT']
  end

  def upload_to_ipfs(content, content_type)
    uri = URI.join(@api_endpoint, 'upload')
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{@api_key}"
  
    case content_type
    when :file
      file = File.open(content)
      request.body = file.read
    when :json
      request.body = content
      request.content_type = 'application/json'
    else
      raise "Invalid content type specified"
    end

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    ensure
      file&.close if content_type == :file
    end
  
    return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    
    raise "Failed to upload to IPFS: #{response.body}"
  end
  
  private
end
