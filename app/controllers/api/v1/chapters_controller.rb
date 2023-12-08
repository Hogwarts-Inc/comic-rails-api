# frozen_string_literal: true

module Api
  module V1
    class ChaptersController < BaseController
      before_action :set_chapter, only: %i[show update destroy]
      before_action :authorize, except: [:index, :show]

      # GET /api/v1/chapters
      def index
        @chapters = Chapter.active

        render json: @chapters.select { |chapter| chapter.canvas.active.any? }
                              .map { |chapter| chapter.as_json.merge(chapter_attributes(chapter)) }
      end

      # GET /api/v1/chapters/1
      def show
        render json: @chapter.as_json.merge(chapter_attributes(@chapter))
      end

      # POST /api/v1/chapters
      def create
        @chapter = Chapter.new(chapter_params)

        if @chapter.save
          render json: @chapter.as_json.merge(chapter_attributes(@chapter))
        else
          render json: @chapter.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/chapters/1
      def update
        if @chapter.update(chapter_params)
          render json: @chapter.as_json.merge(chapter_attributes(@chapter))
        else
          render json: @chapter.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/chapters/1
      def destroy
        @chapter.destroy
      end

      private

      def chapter_attributes(chapter)
        {
          chapter_like_count: chapter.total_likes_count,
          canvas: chapter.canvas.active.map { |canva| canva_json(canva) }
        }
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_chapter
        @chapter = Chapter.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def chapter_params
        params.require(:chapter).permit(:title, :description, :active, :storiette_id)
      end

      def canva_json(canva)
        canva.as_json.merge(
          {
             image_url: url_for(canva.image),
             likes: canva.likes_count
          }
        )
      end
    end
  end
end
