# frozen_string_literal: true

module Api
  module V1
    class TermsAndConditionsController < BaseController
      before_action :set_terms_and_condition, only: %i[show]

      # GET /api/v1/terms_and_conditions
      def index
        @terms_and_conditions = TermsAndCondition.active

        render json: @terms_and_conditions.active.first.as_json.merge({ file_url: url_for(terms_and_condition.file) })
      end

      # GET /api/v1/terms_and_conditions/1
      def show
        if !@terms_and_condition.active?
          error_message = 'El termino y condicion no puede ser accedido porque no existe o no tiene autorización'
          return render json: { error: error_message }, status: :forbidden
        end

        render json: @terms_and_condition.as_json.merge({ file_url: url_for(@terms_and_condition.file) })
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_terms_and_condition
        @terms_and_condition = TermsAndCondition.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def terms_and_condition_params
        params.permit(:file, :active)
      end
    end
  end
end
