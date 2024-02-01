require 'net/http'
require 'uri'
require 'json'

class CrossmintService
  def initialize
    @api_key = ENV['CROSSMINT_STAGING_API_KEY']
    @api_endpoint = ENV['CROSSMINT_STAGING_URL']
  end

  def create_wallet(user_email)
    uri = URI.join(@api_endpoint, 'v1-alpha1/wallets')
    request = Net::HTTP::Post.new(uri)
    request['X-API-KEY'] = @api_key
    request.content_type = "application/json"
    request.body = { chain: "polygon", email: user_email }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
