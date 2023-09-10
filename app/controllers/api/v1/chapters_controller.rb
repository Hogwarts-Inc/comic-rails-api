# frozen_string_literal: true

module Api
  module V1
    class ChaptersController < BaseController
      before_action :set_chapter, only: %i[show update destroy]

      # GET /api/v1/chapters
      def index
        @chapters = Chapter.all

        render json: @chapters, include: :canvas
      end

      # GET /api/v1/chapters/1
      def show
        render json: @chapter, include: :canvas
      end

      # POST /api/v1/chapters
      def create
        @chapter = Chapter.new(chapter_params)

        if @chapter.save
          render json: @chapter, status: :created
        else
          render json: @chapter.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/chapters/1
      def update
        if @chapter.update(chapter_params)
          render json: @chapter
        else
          render json: @chapter.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/chapters/1
      def destroy
        @chapter.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_chapter
        @chapter = Chapter.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def chapter_params
        params.require(:chapter).permit(:title, :description, :storiette_id)
      end
    end
  end
end
