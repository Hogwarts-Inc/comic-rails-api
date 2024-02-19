# frozen_string_literal: true

module Api
  module V1
    class LogosController < BaseController
      before_action :set_logo, only: %i[show update destroy]

      # GET /api/v1/logos
      def index
        @logos = Logo.active

        render json: @logos.active.map { |logo| logo.as_json.merge({ image_url: url_for(logo.image) }) }
      end

      # GET /api/v1/logos/1
      def show
        render json: @logo.as_json.merge({ image_url: url_for(@logo.image) })
      end

      # POST /api/v1/logos
      def create
        @logo = Logo.new(logo_params)

        if @logo.save
          render json: @logo.as_json.merge({ image_url: url_for(@logo.image) })
        else
          render json: @logo.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/logos/1
      def update
        if @logo.update(logo_params)
          render json: @logo.as_json.merge({ image_url: url_for(@logo.image) })
        else
          render json: @logo.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/logos/1
      def destroy
        @logo.destroy
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
