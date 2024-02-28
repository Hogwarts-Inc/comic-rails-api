module Api
  module V1
    class QueueTimesController < BaseController
      before_action :set_queue_time, only: %i[show]
      before_action :authorize, except: [:remove_user_time, :index, :show]

      # GET /api/v1/queue_times
      def index
        @queue_times = QueueTime.active

        render json: @queue_times.active
      end

      # GET /api/v1/queue_times/1
      def show
        if !@queue_time.active?
          error_message = 'El tiempo de cola no puede ser accedido porque no existe o no tiene autorización'
          return render json: { error: error_message }, status: :forbidden
        end

        render json: @queue_time
      end

      def remove_user_time
        @time = QueueTime.active.first

        render json: { time: @time&.remove_from_queue_time || 15 }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_queue_time
        @queue_time = QueueTime.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def queue_time_params
        params.permit(:remove_from_queue_time, :active)
      end
    end
  end
end
