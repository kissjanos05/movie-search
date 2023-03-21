##
# This class responsible to process movies list
class MoviesClient

  attr_reader :query_string, :page

  def initialize query_string, page
    @query_string = query_string
    @page = page || 1
  end

  def search
    query = Query.within_time.find_by(query: query_string, page: page)
    if query
      query.inc(hit_count: 1)
      return query
    end
    
    get_and_save_from_tmdb
  end

  private

  def get_and_save_from_tmdb
    params = {
      api_key:  Rails.configuration.tmdb.api_key,
      page: page,
      query: query_string
    }

    RestClient.get(Rails.configuration.tmdb.search_url, params: params) do |response|
      case response.code
      when 200
        _response = JSON.parse(response.body)
        # Filters out the unnecessary attributes
        movies = _response['results'].map{|movie| movie.slice(*Movie.fields.keys) }
        Query.create!(query: query_string, page: page, total_pages: _response['total_pages'], total_results: _response['total_results'], movies: movies)
      when 401
        raise TmdbExceptions::ApiError, '401'
      when 404
        raise TmdbExceptions::ApiError, '404'
      else
        raise TmdbExceptions::ApiError, response.code
      end
    end
  rescue SocketError
    raise TmdbExceptions::ApiError, '500'
  end

end
