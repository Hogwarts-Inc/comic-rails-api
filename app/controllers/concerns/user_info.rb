module UserInfo
  extend ActiveSupport::Concern

  REQUIRES_AUTHENTICATION = { message: 'Requires authentication' }.freeze
  BAD_CREDENTIALS = {
    message: 'Bad credentials'
  }.freeze
  MALFORMED_AUTHORIZATION_HEADER = {
    error: 'invalid_request',
    error_description: 'Authorization header value must follow this format: Bearer access-token',
    message: 'Bad credentials'
  }.freeze

  def user_info
    token = token_from_request

    return false unless token.present?

    user_info = Auth0Client.get_user_info(token)

    if user_info == 'Failed to fetch user information' ||
       user_info == 'Authorization token not present in the request'
      false
    else
      user_info
    end
  end

  private

  def token_from_request
    authorization_header_elements = request.headers['Authorization']&.split

    return unless authorization_header_elements

    unless authorization_header_elements.length == 2
      return
    end

    scheme, token = authorization_header_elements

    return unless scheme.downcase == 'bearer'

    token
  end
end
