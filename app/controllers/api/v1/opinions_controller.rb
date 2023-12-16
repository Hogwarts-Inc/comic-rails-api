module Api
  module V1
    class OpinionsController < BaseController
      include UserInfo

      before_action :set_opinion, only: %i[show]
      before_action :get_user_info
      before_action :authorize, except: [:index, :show]

      # GET /api/v1/opinions
      def index
        @opinions = Opinion.active

        render json: @opinions.active
      end

      # GET /api/v1/opinions/1
      def show
        render json: @opinion
      end

      # POST /api/v1/opinions
      def create
        @opinion = Opinion.new(opinion_params)

        if @opinion.save
          render json: @opinion
        else
          render json: @opinion.errors, status: :unprocessable_entity
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_opinion
        @opinion = Opinion.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def opinion_params
        opinion_attributes = params.permit(:canva_id, :active, :text)

        return render json: { error: 'No hay usuario' }, status: :unprocessable_entity unless @user.present?

        opinion_attributes[:user_profile_id] = @user.id

        opinion_attributes
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
