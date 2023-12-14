module Api
  module V1
    class LikesController < BaseController
      include UserInfo

      before_action :set_like, only: %i[show update]
      before_action :get_user_info
      before_action :authorize, except: [:index, :show]

      # GET /api/v1/likes
      def index
        @likes = Like.all

        render json: @likes
      end

      # GET /api/v1/likes/1
      def show
        render json: @like
      end

      # POST /api/v1/likes
      def create
        @like = Like.new(like_params)

        if @like.save
          render json: @like
        else
          render json: @like.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/likes/1
      def update
        if @like.update(like_params)
          render json: @like
        else
          render json: @like.errors, status: :unprocessable_entity
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_like
        @like = Like.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def like_params
        like_attributes = params.permit(:canva_id)

        return render json: 'No hay usuario' unless @user.present?

        like_attributes[:user_profile_id] = @user.id

        like_attributes
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
