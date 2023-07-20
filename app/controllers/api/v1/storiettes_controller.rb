class Api::V1::StoriettesController < ApplicationController
  before_action :set_storiette, only: %i[ show update destroy ]

  # GET /storiettes
  def index
    @storiettes = Storiette.all

    render json: @storiettes
  end

  # GET /storiettes/1
  def show
    render json: @storiette
  end

  # POST /storiettes
  def create
    @storiette = Storiette.new(storiette_params)

    if @storiette.save
      render json: @storiette, status: :created
    else
      render json: @storiette.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /storiettes/1
  def update
    if @storiette.update(storiette_params)
      render json: @storiette
    else
      render json: @storiette.errors, status: :unprocessable_entity
    end
  end

  # DELETE /storiettes/1
  def destroy
    @storiette.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_storiette
      @storiette = Storiette.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def storiette_params
      params.require(:storiette).permit(:title, :description, :image)
    end
end
