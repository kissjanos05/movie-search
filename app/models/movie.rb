class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  # FIELDS
  field :original_title, type: String
  field :overview, type: String
  field :poster_path, type: String
  field :release_date, type: Date
  field :title, type: String
  
  # ASSOCIATIONS
  embedded_in :query 

end
