class FavoritesController < ApplicationController
  before_action :set_activity, only: %i[create destroy]

  def index
    @activities = current_user.favorite_activities.order("favorites.created_at DESC")
    @favorite_ids = @activities.ids
  end

  def create
    current_user.favorites.find_or_create_by!(activity: @activity)
    respond_with_button(true)
  end

  def destroy
    current_user.favorites.find_by(activity: @activity)&.destroy
    respond_with_button(false)
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def respond_with_button(favorited)
    @favorited = favorited
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: @activity, status: :see_other }
    end
  end
end
