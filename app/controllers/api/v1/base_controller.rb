# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApiController
      include Secured

      rescue_from StandardError do |e|
        render json: { message: e.message }, status: :internal_server_error
      end
    end
  end
end
