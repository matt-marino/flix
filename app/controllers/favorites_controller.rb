class FavoritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def create
    @movie.favorites.create!(user: current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @movie }
    end
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @movie }
    end
  end

  private

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end
end
