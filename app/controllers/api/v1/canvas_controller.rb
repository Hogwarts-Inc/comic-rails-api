# frozen_string_literal: true

module Api
  module V1
    class CanvasController < BaseController
      include UserInfo

      before_action :set_canva, only: %i[show update destroy remove_like]
      before_action :authorize, except: [:index, :show, :remove_like]
      before_action :get_user_info, only: %i[show create remove_like]

      # GET /api/v1/canvas
      def index
        @canvas = Canva.active
                       .select { |canva| canva.chapter.active? && canva.chapter.storiette.active? }

        render json: @canvas.map { |canva|
          canva.as_json.merge!(canva_data(canva))
        }
      end

      # GET /api/v1/canvas/1
      def show
        render json: @canva.as_json.merge!(canva_data(@canva))
      end

      # POST /api/v1/canvas
      def create
        return render json: { error: 'El usuario no existe' } unless @user.present?

        chapter_id = params[:chapter_id]
        images = params[:images]
        images = [images] unless images.is_a?(Array)
        created_canvas = []

        # return render json: { error: 'El tamaño o dimension de la imagen es incorrecta' } unless validate_images(images)

        images.each do |image|
          @canva = Canva.new(chapter_id: chapter_id, image: image, user_profile_id: @user.id)

          if @canva.save
            created_canvas << @canva
          else
            return render json: @canva.errors, status: :unprocessable_entity
          end
        end

        RemoveCanvaFromQueueJob.perform_async(chapter_id, @user.sub)

        render json: created_canvas.map { |canva|
          canva.as_json.merge!(canva_data(canva))
        }
      end

      # PATCH/PUT /api/v1/canvas/1
      def update
        if @canva.update(canva_params)
          render json: @canva.as_json.merge!(canva_data(@canva))
        else
          render json: @canva.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/canvas/1
      def destroy
        @canva.destroy
      end

      def remove_like
        @like = Like.find_by(canva_id: @canva.id, user_profile_id: @user.id)

        return render json: { error: 'No existe el like' }, status: :unprocessable_entity unless @like.present?

        @like.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_canva
        @canva = Canva.find(params[:id])
      end

      def canva_data(canva)
        {
          image_url: url_for(canva.image),
          user_attributes: canva&.user_profile&.as_json&.merge(
            image_url: user_image(canva&.user_profile)
          ),
          likes: canva.likes_count,
          comments: canva.opinions.active.map { |opinion| opinion.as_json.merge(option_attribute(opinion)) },
          current_user_likes: canva.user_gave_like(@user)
        }
      end

      def validate_image_dimensions_and_size(base64_image)
        image_data = Base64.decode64(base64_image)
        image = MiniMagick::Image.read(image_data)
    
        # Validar dimensiones de la imagen
        max_width = 1024
        max_height = 1024
        if image.width > max_width || image.height > max_height
          return false
        end
    
        # Validar tamaño de la imagen
        max_size = 2.megabytes
        if image_data.size > max_size
          return false
        end
    
        # La imagen cumple con los requisitos
        true
      end

      def user_image(user)
        return nil if user.blank?

        if user.image.present?
          url_for(user.image)
        else
          user.picture
        end
      end

      def option_attribute(opinion)
        {
          user_attributes: opinion&.user_profile&.as_json&.merge(
            image_url: user_image(opinion&.user_profile)
          )
        }
      end

      def validate_images(images)
        validate = true

        images.each do |image|
          image_validate = ValidateImageSizeDimensionService.validate(image)

          validate = false unless image_validate
        end

        validate
      end

      # Only allow a list of trusted parameters through.
      def canva_params
        params.permit(:image, :title, :active, :chapter_id, :user_profile_id)
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
