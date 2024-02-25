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
        return render json: { error: 'El usuario no existe' }, status: :unprocessable_entity unless @user.present?

        chapter_id = params[:chapter_id]
        images = params[:images]
        images = [images] unless images.is_a?(Array)
        created_canvas = []

        validated_images_message = validate_images(images)
        return render json: { error: validated_images_message }, status: :unprocessable_entity unless validated_images_message.flatten.blank?

        images.each do |image|
          @canva = Canva.new(chapter_id: chapter_id, image: image, user_profile_id: @user.id)

          if @canva.save
            created_canvas << @canva
          else
            return render json: @canva.errors, status: :unprocessable_entity
          end
        end

        RemoveUserFromQueueJob.perform_async(chapter_id, @user.sub)
        CanvasQueueService.remove_schedule_by_job_and_arguments(
          'RemoveUserFromQueueJob', [chapter_id.to_i, @user.sub]
        )

        render json: created_canvas.map { |canva|
          canva.as_json.merge!(canva_data(canva))
        }
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
        data = {
          image_url: url_for(canva.image),
          user_attributes: canva&.user_profile&.as_json&.merge(
            image_url: user_image(canva&.user_profile)
          ),
          likes: canva.likes_count,
          comments: canva.opinions.active.map { |opinion| opinion.as_json.merge(option_attribute(opinion)) },
          current_user_likes: canva.user_gave_like(@user)
        }

        if nft_flag_on?
          data[:nft_data] = {
            token_id: canva&.nft_asset&.token_id,
            wallet_address: canva&.user_profile&.wallet_address,
            transferred: NftTransaction.exists?(nft_asset_id: canva&.nft_asset&.id, transaction_type: 'transferring')
          }
        end

        data
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
        image_errors = []

        (0..2).each do |index|
          image_error = []

          if images[index].nil?
            image_errors << image_error
            next
          end

          image_validate = ValidateImageSizeDimensionService.validate_with_errors(images[index])

          if image_validate.include?("Solo permitimos estos archivos imagenes: JPEG, PNG or JPG.")
            image_error << { id_error: 1, error: "Solo permitimos estos archivos imagenes: JPEG, PNG or JPG." }
          end

          if image_validate.include?("Subir imagen que este entre 500x500 a 1500x1500.")
            image_error << { id_error: 2, error: "Subir imagen que este entre 500x500 a 1500x1500." }
          end

          if image_validate.include?("Subir imagen que sea cuadrada.")
            image_error << { id_error: 3, error: "Subir imagen que sea cuadrada." }
          end

          image_errors << image_error
        end

        image_errors
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

      def nft_flag_on?
        ENV['NFT_TOGGLE'] == 'true'
      end
    end
  end
end
