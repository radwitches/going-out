class WelcomeController < ApplicationController
  def index
  end

  def near
    render json: Destination.field_scope.near(
      params[:lat],
      params[:lng]
    ).limit(50).as_json(
      from_lat: params[:lat],
      from_lng: params[:lng]
    )
  end

  def amenities
    Amenity.near(
      Destination.find(
        params[:destination]
      )
    )
  end
end
