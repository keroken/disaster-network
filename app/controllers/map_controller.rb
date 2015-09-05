class MapController < ApplicationController
  def index
    @microposts = Micropost.all
    @hash = Gmaps4rails.build_markers(@microposts) do |micropost, marker|
      marker.lat micropost.latitude
      marker.lng micropost.longitude
      marker.json({title: micropost.title})
      marker.infowindow micropost.content
    end
  end
end
