##
# This class responsible to process movies list
class MoviesClient

  TMDB_API_KEY = YAML.load(File.read(Rails.root.join('config', 'tmdb.yml')))['tmdb']['api_key']

  attr_reader :query_string, :page

  def initialize query_string, page
    @query_string = query_string
    @page = page
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
      api_key: TMDB_API_KEY,
      page: page,
      query: query_string
    }
    response = JSON.parse(RestClient.get('https://api.themoviedb.org/3/search/movie', params: params).body)

    # Filters out the unnecessary attributes
    movies = response['results'].map{|movie| movie.slice(*Movie.fields.keys) }
    Query.create!(query: query_string, page: page, total_pages: response['total_pages'], total_results: response['total_results'], movies: movies)
  end

end
