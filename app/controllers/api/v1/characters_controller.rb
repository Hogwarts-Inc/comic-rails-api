# frozen_string_literal: true

module Api
  module V1
    class CharactersController < BaseController
      before_action :set_character, only: %i[show update destroy]

      # GET /api/v1/characters
      def index
        @characters = Character.all

        render json: @characters.map { |character| character.merge_image_and_description }
      end

      # GET /api/v1/characters/1
      def show
        render json: @character.merge_image_and_description
      end

      # POST /api/v1/characters
      def create
        @character = Character.new(character_params)

        if @character.save
          render json: @character.merge_image_and_description, status: :created
        else
          render json: @character.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/characters/1
      def update
        if @character.update(character_params)
          render json: @character.merge_image_and_description
        else
          render json: @character.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/characters/1
      def destroy
        @character.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_character
        @character = Character.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def character_params
        params.permit(:name, :images, :description_ids)
      end
    end
  end
end
