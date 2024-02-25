module Api
  module V1
    class GraphicResourcesController < BaseController
      before_action :set_graphic_resource, only: %i[ show update destroy ]
      before_action :authorize, except: [:index, :show]

      # GET /api/v1/graphic_resources
      def index
        @graphic_resources = GraphicResource.all

        render json: @graphic_resources.map { |graphic_resource|
          graphic_resource.as_json.merge({ image_url: url_for(graphic_resource.image) })
        }
      end

      # GET /api/v1/graphic_resources/1
      def show
        render json: @graphic_resource.as_json.merge({ image_url: url_for(@graphic_resource.image) })
      end

      # Get /api/v1/graphic_resources/resource_for_type
      def resource_for_type
        resource_type = params[:resource_type]

        @graphic_resources = GraphicResource.where(resource_type: resource_type)

        render json: @graphic_resources.map { |graphic_resource|
          graphic_resource.as_json.merge({ image_url: url_for(graphic_resource.image) })
        }
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_graphic_resource
        @graphic_resource = GraphicResource.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def graphic_resource_params
        params.permit(:resource_type, :image)
      end
    end
  end
end
