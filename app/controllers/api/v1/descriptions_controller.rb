# frozen_string_literal: true

module Api
  module V1
    class DescriptionsController < BaseController
      before_action :set_description, only: %i[show update destroy]
      before_action :authorize, except: [:index, :show]

      # GET /api/v1/descriptions
      def index
        @descriptions = Description.active

        render json: @descriptions
      end

      # GET /api/v1/descriptions/1
      def show
        if !@description.active?
          error_message = 'La descripcion no puede ser accedida porque no existe o no tiene autorización'
          return render json: { error: error_message }, status: :forbidden
        end

        render json: @description
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_description
        @description = Description.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def description_params
        params.require(:description).permit(:title, :text, :active, :descriptionable_id, :descriptionable_type)
      end
    end
  end
end
