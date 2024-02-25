# frozen_string_literal: true

module Api
  module V1
    class CharactersController < BaseController
      before_action :set_character, only: %i[show update destroy]
      before_action :authorize, except: [:index, :show]

      # GET /api/v1/characters
      def index
        @characters = Character.active

        render json: @characters.map { |character| merge_image_and_description(character) }
      end

      # GET /api/v1/characters/1
      def show
        render json: merge_image_and_description(@character)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_character
        @character = Character.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def character_params
        params.permit(:name, :images, :active, :description_ids)
      end

      def merge_image_and_description(character)
        character.as_json.merge({
          images_urls: character.images.map { |image| url_for(image) },
          descriptions: character.descriptions.active.map { |description| description.slice(
            :id, :title, :text, :active
          )}
        })
      end
    end
  end
end
