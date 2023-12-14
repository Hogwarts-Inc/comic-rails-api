module Api
  module V1
    class UserProfilesController < ApplicationController
      include UserInfo

      skip_before_action :verify_authenticity_token
      before_action :get_user_info, only: [:create, :update_profile, :canvas, :info]

      def create
        # if already exists, it won't create the user but will return the user json
        @user = UserProfile.find_by(sub: @user_params['sub'])
        return render json: @user.as_json if @user.present?

        @user = UserProfile.new(@user_params)

        if @user.save
          render json: @user.as_json
        else
          render json: @user.errors
        end
      end

      def update_profile
        @user = UserProfileService.find_or_create(@user_params)

        if @user.update(user_params)
          render json: @user.as_json.merge({
            image_url: user_image(@user)
          })
        else
          render json: @user.errors
        end
      end

      def canvas
        @user = UserProfileService.find_or_create(@user_params)

        return render json: { error: 'User not found' }, status: :unprocessable_entity unless @user.present?

        render json: @user.canvas
                          .active
                          .select { |canva| canva.chapter.active? && canva.chapter.storiette.active? }
                          .map { |canva| canva_data(canva) }
      end

      def info
        @user = UserProfileService.find_or_create(@user_params)

        return render json: { error: 'User not found' }, status: :unprocessable_entity unless @user.present?

        render json: @user.as_json.merge({
          image_url: user_image(@user)
        })
      end

      private

      def canva_data(canva)
        {
          canva_id: canva.id,
          image_url: url_for(canva.image),
          likes: canva.likes_count,
          comments: canva.opinions.as_json
        }
      end

      def user_params
        params.permit(:email, :given_name, :family_name, :picture, :name, :image, :nft_url)
      end

      def user_image(user)
        return nil if user.blank?

        if user.image.present?
          url_for(user.image)
        else
          user.picture
        end
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
