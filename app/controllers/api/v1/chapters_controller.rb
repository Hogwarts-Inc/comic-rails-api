# frozen_string_literal: true

module Api
  module V1
    class ChaptersController < BaseController
      include UserInfo

      before_action :set_chapter, only: %i[show update destroy check_queue user_position_in_queue remove_user_from_queue last_three_canvas add_user_to_queue]
      before_action :authorize, except: [:index, :show, :check_queue, :user_position_in_queue, :remove_user_from_queue, :last_three_canvas, :add_user_to_queue]
      before_action :get_user_info, only: %i[check_queue user_position_in_queue remove_user_from_queue last_three_canvas add_user_to_queue]

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

      def add_user_to_queue
        return render json: { error: 'No hay usuario' }, status: :unprocessable_entity unless @user.present?
        return render json: { error: 'El capitulo no existe' }, status: :unprocessable_entity unless @chapter.present?

        begin
          user_queue = CanvasQueueService.user_in_queue?(@chapter.id, @user.sub)

          if user_queue == :have_user
            # Here we are adding the new user to the queue and putting the correct time of removing the user from the queue
            # The remove will be added when a user is removed.
            AddUserToQueueJob.perform_async(@chapter.id, @user.sub)
            sleep(0.3)
            user_position = CanvasQueueService.user_position_in_queue(@chapter.id, @user.sub)

            render json: { position: user_position, message: "El usuario se agrego en la cola correctamente" }
          elsif user_queue == :first_user_in_queue
            user_position = CanvasQueueService.user_position_in_queue(@chapter.id, @user.sub)
            render json: { position: user_position, message: 'El usuario ya esta en la cola' }
          elsif user_queue == :user_in_queue
            user_position = CanvasQueueService.user_position_in_queue(@chapter.id, @user.sub)
            render json: { position: user_position, message: 'El usuario ya esta en la cola pero no es el primero' }
          else
            AddUserToQueueJob.perform_async(@chapter.id, @user.sub)
            minutes_to_remove = QueueTime.active.first&.remove_from_queue_time || 15
            RemoveUserFromQueueJob.perform_in(minutes_to_remove.minutes, @chapter.id, @user.sub)
            sleep(0.3)
            user_position = CanvasQueueService.user_position_in_queue(@chapter.id, @user.sub)

            render json: { position: user_position, message: "El usuario se agrego en la cola correctamente" }
          end
        rescue StandardError => e
          render json: { error: "Error: #{e.message}" }, status: :unprocessable_entity
        end
      end

      def check_queue
        return render json: { error: 'No hay usuario' }, status: :unprocessable_entity unless @user.present?
        return render json: { error: 'El capitulo no existe' }, status: :unprocessable_entity unless @chapter.present?

        begin
          user_queue = CanvasQueueService.user_in_queue?(@chapter.id, @user.sub)

          if user_queue == :have_user
            render json: { error: 'Ya hay usuarios en la cola' }, status: :unprocessable_entity
          elsif user_queue == :first_user_in_queue
            render json: { message: 'Puede entrar ya que es su turno' }
          elsif user_queue == :user_in_queue
            render json: { error: 'No puede entrar ya que hay alguien en la cola antes' }, status: :unprocessable_entity
          else
            render json: { message: 'Puede entrar ya que no hay nadie en la cola' }
          end
        rescue StandardError => e
          render json: { error: "Error: #{e.message}" }, status: :unprocessable_entity
        end
      end

      def user_position_in_queue
        return render json: { error: 'No hay usuario' }, status: :unprocessable_entity unless @user.present?
        return render json: { error: 'El capitulo no existe' }, status: :unprocessable_entity unless @chapter.present?

        begin
          user_position = CanvasQueueService.user_position_in_queue(@chapter.id, @user.sub)
          render json: { position: user_position }
        rescue StandardError => e
          render json: { error: "Error: #{e.message}" }, status: :unprocessable_entity
        end
      end

      def remove_user_from_queue
        return render json: { error: 'No hay usuario' }, status: :unprocessable_entity unless @user.present?
        return render json: { error: 'El capitulo no existe' }, status: :unprocessable_entity unless @chapter.present?

        begin
          RemoveUserFromQueueJob.perform_async(@chapter.id, @user.sub)
          CanvasQueueService.remove_schedule_by_job_and_arguments(
            'RemoveUserFromQueueJob', [@chapter.id, @user.sub]
          )
          render json: { message: 'El usuario se elimino de la cola correctamente' }
        rescue StandardError => e
          render json: { error: "Error: #{e.message}" }, status: :unprocessable_entity
        end
      end

      def last_three_canvas
        return render json: { error: 'No hay usuario' }, status: :unprocessable_entity unless @user.present?
        return render json: { error: 'El capitulo no existe' }, status: :unprocessable_entity unless @chapter.present?

        begin
          canvas = @chapter.canvas.order("created_at DESC").limit(3).map { |canva| canva_json(canva) }
          render json: { canvas: canvas }
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
        @token = token_from_request()
        @user = UserProfileService.find_user_by_session(@token) if @token.present?

        unless @user.present?
          user_info = user_info()

          if user_info.present?
            user_params = user_info.slice('email', 'given_name', 'family_name', 'sub', 'picture', 'name')
            @user = UserProfileService.find_or_create(user_params)

            create_user_session
          else
            @user = nil
          end
        end

        @user
      end

      def create_user_session
        TokenSession.create(user_profile_id: @user.id, token: @token)
      end
    end
  end
end
