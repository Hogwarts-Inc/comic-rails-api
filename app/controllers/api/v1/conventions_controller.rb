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
        render json: merge_image_and_description(@convention)
      end

      # POST /api/v1/conventions
      def create
        @convention = Convention.new(convention_params)

        if @convention.save
          render json: merge_image_and_description(@convention), status: :created
        else
          render json: @convention.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/conventions/1
      def update
        if @convention.update(convention_params)
          render json: merge_image_and_description(@convention)
        else
          render json: @convention.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/conventions/1
      def destroy
        @convention.destroy
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
