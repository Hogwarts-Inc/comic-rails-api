# frozen_string_literal: true

module Api
  module V1
    class StoriettesController < BaseController
      before_action :set_storiette, only: %i[show update destroy]
      before_action :authorize, except: [:index]

      # GET /api/v1/storiettes
      def index
        @storiettes = Storiette.all

        render json: @storiettes, include: :chapters
      end

      # GET /api/v1/storiettes/1
      def show
        render json: @storiette, include: :chapters
      end

      # POST /api/v1/storiettes
      def create
        @storiette = Storiette.new(storiette_params)

        if @storiette.save
          render json: @storiette, status: :created
        else
          render json: @storiette.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/storiettes/1
      def update
        if @storiette.update(storiette_params)
          render json: @storiette
        else
          render json: @storiette.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/storiettes/1
      def destroy
        @storiette.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_storiette
        @storiette = Storiette.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def storiette_params
        params.require(:storiette).permit(:title, :description, :image)
      end
    end
  end
end
