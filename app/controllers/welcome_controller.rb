class WelcomeController < ApplicationController
  def index
  end

  def near
    render json: Destination.near(
      params[:lat],
      params[:lng]
    ).limit(50).as_json(
      from_lat: params[:lat],
      from_lng: params[:lng]
    )
  end
end
