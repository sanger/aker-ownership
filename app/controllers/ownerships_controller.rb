
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
    # Batch upsert does not seem to be possible.
    # Instead, separate out the creates and updates.
    #   Batch update does not seem to be possible.
    #   However, batch create is definitely possible.
    modelidhash = {}
    # I don't know what the expected behaviour is if the same model id is passed twice,
    #  so abort if a duplicate is found.
    params.require(:ownership).each do |item|
      modelid = item.require(:model_id)
      if modelidhash.has_key?(modelid)
        error = {
          status: 400,
          message: "Repeated model id: #{modelid.inspect}"
        }
        return render json: error, status: :bad_request
      end
      modelidhash[modelid] = item.permit(:model_id, :model_type, :owner_id)
    end

    modelids = modelidhash.keys

    Ownership.transaction do

      # Find which of the model ids are already in the database and update them
      Ownership.where(model_id: modelids).find_each do | ownership |
        modelid = ownership.model_id
        ownership.update_attributes!(modelidhash[modelid])
        # Any that we have updated this way, we don't need to create in the next step
        modelidhash.delete(modelid)
      end
      # For items that we still need to create, do them all as a batch
      Ownership.create!(modelidhash.values) unless modelidhash.empty?
      # Load the results for the response
      @ownerships = Ownership.where(model_id: modelids)
      
    end # -- transaction

    render json: @ownerships, status: :created
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ownership
      @ownership = Ownership.find(params[:model_id])
    end

    # Only allow a trusted parameter "white list" through.
    def ownership_params
      params.require(:ownership).permit(:model_id, :model_type, :owner_id)
    end
end
