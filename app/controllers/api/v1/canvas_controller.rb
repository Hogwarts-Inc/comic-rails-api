# frozen_string_literal: true

module Api
  module V1
    class CanvasController < BaseController
      include UserInfo

      before_action :set_canva, only: %i[show update destroy]
      before_action :authorize, except: [:index, :show]
      before_action :get_user_info, only: %i[show]

      # GET /api/v1/canvas
      def index
        @canvas = Canva.active

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
        chapter_id = params[:chapter_id]
        user_profile_id = params[:user_profile_id]
        images = params[:images]

        images = [images] unless images.is_a?(Array)
        created_canvas = []

        images.each do |image|
          @canva = Canva.new(chapter_id: chapter_id, image: image, user_profile_id: user_profile_id)

          if @canva.save
            created_canvas << @canva
          else
            return render json: @canva.errors, status: :unprocessable_entity
          end
        end

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

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_canva
        @canva = Canva.find(params[:id])
      end

      def canva_data(canva)
        {
          image_url: url_for(canva.image),
          user_attributes: canva&.user_profile&.as_json&.merge(
            image_ur: user_image(canva&.user_profile)
          ),
          likes: canva.likes_count,
          comments: canva.opinions.as_json,
          current_user_likes: canva.user_gave_like(@user_params)
        }
      end

      def user_image(user)
        return nil if user.blank?

        if user.image.present?
          url_for(user.image)
        elsif user.picture.present?
          user.picture
        elsif
          user.nft_url
        end
      end

      # Only allow a list of trusted parameters through.
      def canva_params
        params.permit(:image, :title, :active, :chapter_id, :user_profile_id)
      end

      def get_user_info
        user_info = user_info()

        if user_info.present?
          @user_params = user_info.slice('email', 'given_name', 'family_name', 'sub', 'picture', 'name')
        else
          @user_params = {}
        end
      end
    end
  end
end
