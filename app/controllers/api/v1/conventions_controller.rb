# frozen_string_literal: true

module Api
  module V1
    class ConventionsController < BaseController
      before_action :set_convention, only: %i[show update destroy]
      before_action :authorize, except: [:index, :show]

      # GET /api/v1/conventions
      def index
        @conventions = Convention.active

        render json: @conventions.map { |convention| merge_image_and_description(convention) }
      end

      # GET /api/v1/conventions/1
      def show
        if !@convention.active?
          error_message = 'El evento no puede ser accedido porque no existe o no tiene autorización'
          return render json: { error: error_message }, status: :forbidden
        end

        render json: merge_image_and_description(@convention)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_convention
        @convention = Convention.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def convention_params
        params.permit(:name, :image, :active, :description_ids)
      end


      def merge_image_and_description(convention)
        convention.as_json.merge({
          image_url: url_for(convention.image),
          descriptions: convention.descriptions.active.map { |description| description.slice(
            :id, :title, :text, :active
          )}
        })
      end
    end
  end
end
