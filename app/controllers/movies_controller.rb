class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @movies = Movie.send(movies_filter)
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)

    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      respond_to do |format|
        format.turbo_stream
        format.html { render(:edit) }
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to(@movie, notice: "Movie successfully created!")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    flash.now[:alert] = "Movie successfully deleted!"
  end

  private

  def movie_params
    params.require(:movie).
      permit(
        :title,
        :description,
        :rating,
        :released_on,
        :total_gross,
        :director,
        :duration,
        :main_image,
        genre_ids: [])
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

  def movies_filter
    if params[:filter].in? %w(upcoming recent hits flops)
      params[:filter]
    else
      :released
    end
  end
end
