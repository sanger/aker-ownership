
class OwnershipsController < ApplicationController
  before_action :set_ownership, only: [:show, :update, :destroy]

  # GET /ownerships
  def index
    @ownerships = Ownership.all.limit(1000)

    render json: @ownerships
  end

  # GET /ownerships/1
  def show
    render json: @ownership
  end

  # POST /ownerships
  def create
    @ownership =  Ownership.find_by(:model_id => ownership_params[:model_id])
    if @ownership
      @ownership.update_attributes(ownership_params)
    else
      @ownership = Ownership.new(ownership_params)
    end

    if @ownership.save
      render json: @ownership, status: :created, location: @ownership
    else
      render json: @ownership.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ownerships/1
  def update
    if @ownership.update(ownership_params)
      render json: @ownership
    else
      render json: @ownership.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ownerships/1
  def destroy
    @ownership.destroy
  end

  # POST /ownerships/batch
  # {
  #   "ownership": [
  #      {
  #         "model_id": "xxxxxxxxxxx",
  #         "model_type": "THING",
  #         "owner_id": "jeff@jeff.com"
  #      },
  #      ...
  #   ]
  # }
  def create_batch
    validated_parameters = batch_params
    modelidhash = {}
    # Abort if a model_id is repeated.
    validated_parameters.each do |item|
      modelid = item[:model_id]
      if modelidhash.has_key?(modelid)
        error = {
          status: 400,
          message: "Repeated model id: #{modelid.inspect}"
        }
        return render json: error, status: :bad_request
      end
      modelidhash[modelid] = item
    end

    @ownerships = Ownership.upsert_batch(modelidhash)

    render json: @ownerships, status: :created
  end

  private
    # white list the batch ownership parameters
    def batch_params
      params.permit(:ownership => [ :model_id, :model_type, :owner_id ]).require(:ownership)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_ownership
      @ownership = Ownership.find(params[:model_id])
    end

    # Only allow a trusted parameter "white list" through.
    def ownership_params
      params.require(:ownership).permit(:model_id, :model_type, :owner_id)
    end
end
