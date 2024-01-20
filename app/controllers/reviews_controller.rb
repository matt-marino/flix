class ReviewsController < ApplicationController
  before_action :set_movie
  before_action :set_review, except: [:index, :create, :new]
  before_action :require_signin

  def index
    @reviews = @movie.reviews
  end

  def show
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_reviews_path(@movie),
                    notice: "Thanks for your review!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to(movie_review_path(@movie, @review), notice: "Review successfully updated!")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @review.destroy

    redirect_to(movie_reviews_path(@movie))
  end

  private

  def review_params
    params.require(:review).permit(:comment, :stars)
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end

  def set_review
    @review = Review.find_by(id: params[:id])
  end
end
