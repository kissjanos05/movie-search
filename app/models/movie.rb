class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  # FIELDS
  field :original_title, type: String
  field :overview, type: String
  field :poster_path, type: String
  field :release_date, type: Date
  field :title, type: String
  field :vote_average, type: Float

  # ASSOCIATIONS
  embedded_in :query

  # INSTANCE METHODS

  def img_path
    return nil unless poster_path
    Rails.configuration.tmdb.img_url + poster_path
  end


end
