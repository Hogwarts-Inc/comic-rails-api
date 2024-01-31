module Api
  module V1
    class UserProfilesController < ApplicationController
      include UserInfo

      skip_before_action :verify_authenticity_token
      before_action :create_user_info, only: [:create]
      before_action :get_token, only: [:create]
      before_action :get_user_info, only: [:update_profile, :canvas, :info]

      def create
        # if already exists, it won't create the user but will return the user json
        @user = UserProfile.find_by(sub: @user_params['sub'])
        if @user.present?
          create_user_session
          create_wallet_for_user(@user) unless @user.wallet_address.present?

          return render json: @user.as_json
        end

        @user = UserProfile.new(@user_params)

        if @user.save
          create_user_session
          create_wallet_for_user(@user)

          render json: @user.as_json
        else
          render json: @user.errors
        end
      end

      def update_profile
        if @user.update(user_params)
          render json: @user.as_json.merge({
            image_url: user_image(@user)
          })
        else
          render json: @user.errors
        end
      end

      def canvas
        return render json: { error: 'User not found' }, status: :unprocessable_entity unless @user.present?

        render json: @user.canvas
                          .active
                          .select { |canva| canva.chapter.active? && canva.chapter.storiette.active? }
                          .map { |canva| canva_data(canva) }
      end

      def info
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
        params.permit(:email, :given_name, :family_name, :picture, :name, :image, :wallet_address)
      end

      def user_image(user)
        return nil if user.blank?

        if user.image.present?
          url_for(user.image)
        else
          user.picture
        end
      end

      def create_user_info
        @token = token_from_request()
        @user = UserProfileService.find_user_by_session(@token) if @token.present?

        unless @user.present?
          user_info = user_info()

          if user_info.present?
            @user_params = user_info.slice('email', 'given_name', 'family_name', 'sub', 'picture', 'name')
          else
            @user_params = {}
          end
        else
          @user_params = @user.as_json.slice('email', 'given_name', 'family_name', 'sub', 'picture', 'name')
        end
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
      
      def create_wallet_for_user(user)
        crossmint_service = CrossmintService.new
        begin
          wallet_response = crossmint_service.create_wallet(user.email)
          user.update(wallet_address: wallet_response['publicKey'])
        rescue => e
          Rails.logger.error "Crossmint Wallet Creation Failed: #{e.message}"
        end
      end
      
      def create_user_session
        TokenSession.create(user_profile_id: @user.id, token: @token)
      end

      def get_token
        @token = token_from_request
      end
    end
  end
end
