module Api
  module V1
    class OpinionsController < ApplicationController
      before_action :set_opinion, only: %i[show update destroy]
      #before_action :authorize

      # GET /api/v1/opinions
      def index
        @opinions = Opinion.active

        render json: @opinions.active
      end

      # GET /api/v1/opinions/1
      def show
        render json: @opinion
      end

      # POST /api/v1/opinions
      def create
        @opinion = Opinion.new(opinion_params)

        if @opinion.save
          render json: @opinion
        else
          render json: @opinion.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/opinions/1
      def update
        if @opinion.update(opinion_params)
          render json: @opinion
        else
          render json: @opinion.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/opinions/1
      def destroy
        @opinion.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_opinion
        @opinion = Opinion.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def opinion_params
        params.require(:opinion).permit(:canva_id, :user_profile_id, :active)
      end
    end
  end
end
