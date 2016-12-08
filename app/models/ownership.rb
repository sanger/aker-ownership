class Ownership < ApplicationRecord
	validates :model_id, presence: true
	validates :model_type, presence: true
	validates :owner_id, presence: true
end
