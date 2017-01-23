class Ownership < ApplicationRecord
	validates :model_id, presence: true
	validates :model_type, presence: true
	validates :owner_id, presence: true

    # Batch upsert in the database does not seem to be possible.
    # Instead, separate out the creates and updates.
    #   Batch update does not seem to be possible.
    #   However, batch create is definitely possible.
	def self.upsert_batch(modelidhash)
		modelids = modelidhash.keys
		transaction do
			# Find which of the model ids are already in the database and update them
			where(model_id: modelids).find_each do | ownership |
	        	modelid = ownership.model_id
	        	ownership.update_attributes!(modelidhash[modelid])
	        	# Any that we have updated this way, we don't need to create in the next step
	        	modelidhash.delete(modelid)
	      	end
	      	# For items that we still need to create, do them all as a batch
	      	create!(modelidhash.values) unless modelidhash.empty?
	      	# Load the results for the response
	      	return where(model_id: modelids)
	    end # -- transaction
	end
end
