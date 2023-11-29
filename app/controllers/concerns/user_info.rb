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

    render json: REQUIRES_AUTHENTICATION, status: :unauthorized and return unless authorization_header_elements

    unless authorization_header_elements.length == 2
      render json: MALFORMED_AUTHORIZATION_HEADER, status: :unauthorized and return
    end

    scheme, token = authorization_header_elements

    render json: BAD_CREDENTIALS, status: :unauthorized and return unless scheme.downcase == 'bearer'

    token
  end
end
