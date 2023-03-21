class MoviesController < ApplicationController

  rescue_from TmdbExceptions::ApiError do |exception|
    @error = exception
    render partial: 'layouts/error_alert', status: exception.message
  end

  def index; end

  def search
    movies_client = MoviesClient.new(params[:query], params[:page])
    @result = movies_client.search
    render partial: 'movies/collection', layout: false
  end

end
