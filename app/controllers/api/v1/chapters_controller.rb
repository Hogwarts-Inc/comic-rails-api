# frozen_string_literal: true

module Api
  module V1
    class ChaptersController < BaseController
      include UserInfo

      before_action :set_chapter, only: %i[show update destroy check_queue]
      before_action :authorize, except: [:index, :show, :check_queue]
      before_action :get_user_info, only: %i[check_queue]

      # GET /api/v1/chapters
      def index
        @chapters = Chapter.active
                           .select { |chapter| chapter.storiette.active? }

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

      def check_queue
        return render json: { error: 'No hay usuario' }, status: :unprocessable_entity unless @user.present?
        return render json: { error: 'El capitulo no existe' }, status: :unprocessable_entity unless @chapter.present?

        begin
          if CanvasQueueService.user_in_queue?(@chapter.id)
            render json: { error: "Ya hay alguien creando en el capitulo" }, status: :unprocessable_entity
          else
            AddCanvaToQueueJob.perform_async(@chapter.id, @user.sub)
            RemoveCanvaFromQueueJob.perform_in(15.minutes, @chapter.id, @user.sub)

            render json: { message: 'Puede crear viñeta y se agrego a la cola' }
          end
        rescue StandardError => e
          render json: { error: "Error: #{e.message}" }, status: :unprocessable_entity
        end
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

      def get_user_info
        user_info = user_info()

        if user_info.present?
          user_params = user_info.slice('email', 'given_name', 'family_name', 'sub', 'picture', 'name')
          @user = UserProfileService.find_or_create(user_params)
        else
          @user = nil
        end
      end
    end
  end
end
