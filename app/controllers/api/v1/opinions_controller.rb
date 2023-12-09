module Api
  module V1
    class OpinionsController < BaseController
      include UserInfo

      before_action :set_opinion, only: %i[show update destroy]
      before_action :get_user_info, except: %i[update]
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

      # PATCH/PUT /api/v1/opinions/1
      def update
        if @opinion.update(opinion_params)
          render json: @opinion
        else
          render json: @opinion.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/opinions/1
      def destroy
        @opinion.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_opinion
        @opinion = Opinion.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def opinion_params
        opinion_attributes = params.permit(:canva_id, :active, :text)

        user = UserProfile.find_by(sub: @user_params['sub'])

        return render json: 'No hay usuario' unless user.present?

        opinion_attributes[:user_profile_id] = user.id

        opinion_attributes
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
