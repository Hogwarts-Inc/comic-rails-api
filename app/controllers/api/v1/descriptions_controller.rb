# frozen_string_literal: true

module Api
  module V1
    class DescriptionsController < BaseController
      before_action :set_description, only: %i[show update destroy]

      # GET /api/v1/descriptions
      def index
        @descriptions = Description.all

        render json: @descriptions
      end

      # GET /api/v1/descriptions/1
      def show
        render json: @description
      end

      # POST /api/v1/descriptions
      def create
        @description = Description.new(description_params)

        if @description.save
          render json: @description, status: :created
        else
          render json: @description.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/descriptions/1
      def update
        if @description.update(description_params)
          render json: @description
        else
          render json: @description.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/descriptions/1
      def destroy
        @description.destroy
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
