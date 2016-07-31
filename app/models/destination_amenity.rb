class DestinationAmenity < ApplicationRecord
  belongs_to :amenity
  belongs_to :destination
end
