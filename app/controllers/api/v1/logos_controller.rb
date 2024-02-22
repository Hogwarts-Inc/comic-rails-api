# frozen_string_literal: true

module Api
  module V1
    class LogosController < BaseController
      before_action :set_logo, only: %i[show]

      # GET /api/v1/logos
      def index
        @logos = Logo.active

        render json: @logos.active.map { |logo| logo.as_json.merge({ image_url: url_for(logo.image) }) }
      end

      # GET /api/v1/logos/1
      def show
        render json: @logo.as_json.merge({ image_url: url_for(@logo.image) })
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_logo
        @logo = Logo.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def logo_params
        params.permit(:image, :active)
      end
    end
  end
end
