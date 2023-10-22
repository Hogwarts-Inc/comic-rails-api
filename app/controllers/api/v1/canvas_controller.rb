# frozen_string_literal: true

module Api
  module V1
    class CanvasController < BaseController
      before_action :set_canva, only: %i[show update destroy]

      # GET /api/v1/canvas
      def index
        @canvas = Canva.active

        render json: @canvas.map { |canva|
          canva.as_json.merge({ image_url: url_for(canva.image) })
        }
      end

      # GET /api/v1/canvas/1
      def show
        render json: @canva.as_json.merge({ image_url: url_for(@canva.image) })
      end

      # POST /api/v1/canvas
      def create
        @canva = Canva.new(canva_params)

        if @canva.save
          render json: @canva.as_json.merge({ image_url: url_for(@canva.image) })
        else
          render json: @canva.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/canvas/1
      def update
        if @canva.update(canva_params)
          render json: @canva.as_json.merge({ image_url: url_for(@canva.image) })
        else
          render json: @canva.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/canvas/1
      def destroy
        @canva.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_canva
        @canva = Canva.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def canva_params
        params.permit(:image, :title, :active, :chapter_id)
      end
    end
  end
end
