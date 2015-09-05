class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc) if logged_in?
    
    @microposts = Micropost.all
    @hash = Gmaps4rails.build_markers(@microposts) do |micropost, marker|
      marker.lat micropost.latitude
      marker.lng micropost.longitude
      marker.json({title: micropost.title})
      marker.infowindow micropost.content
    end
  end
end
