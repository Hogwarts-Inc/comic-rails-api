# frozen_string_literal: true

module Api
  module V1
    class TermsAndConditionsController < BaseController
      before_action :set_terms_and_condition, only: %i[show update destroy]

      # GET /api/v1/terms_and_conditions
      def index
        @terms_and_conditions = TermsAndCondition.active

        render json: @terms_and_conditions.active.map { |terms_and_condition| terms_and_condition.as_json.merge({ file_url: url_for(terms_and_condition.file) }) }
      end

      # GET /api/v1/terms_and_conditions/1
      def show
        render json: @terms_and_condition.as_json.merge({ file_url: url_for(@terms_and_condition.file) })
      end

      # POST /api/v1/terms_and_conditions
      def create
        @terms_and_condition = TermsAndCondition.new(terms_and_condition_params)

        if @terms_and_condition.save
          render json: @terms_and_condition.as_json.merge({ file_url: url_for(@terms_and_condition.file) })
        else
          render json: @terms_and_condition.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/terms_and_conditions/1
      def update
        if @terms_and_condition.update(terms_and_condition_params)
          render json: @terms_and_condition.as_json.merge({ file_url: url_for(@terms_and_condition.file) })
        else
          render json: @terms_and_condition.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/terms_and_conditions/1
      def destroy
        @terms_and_condition.destroy
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
