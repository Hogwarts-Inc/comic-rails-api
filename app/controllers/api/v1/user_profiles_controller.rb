module Api
  module V1
    class UserProfilesController < ApplicationController
      include UserInfo

      skip_before_action :verify_authenticity_token
      before_action :get_user_info, only: [:create, :update_profile]

      def create
        # if already exists, it won't create the user but will return the user json
        @user = UserProfile.find_by(sub: @user_params['sub'])
        return render json: { @user.as_json } if @user.present?

        @user = UserProfile.new(@user_params)

        if @user.save
          render json: @user.as_json
        else
          render json: @user.errors
        end
      end

      def update_profile
        @user = UserProfile.find_by(sub: @user_params['sub'])
        binding.pry
        if @user.update(user_params)
          render json: @user.as_json
        else
          render json: @user.errors
        end
      end

      private

      def user_params
        params.permit(:email, :given_name, :family_name, :picture, :name, :image, :nft_url)
      end

      def get_user_info
        user_info = user_info()

        if user_info.present?
          @user_params = user_info.slice('email', 'given_name', 'family_name', 'sub', 'picture', 'name')
        else
          @user_param = {}
        end
      end
    end
  end
end
