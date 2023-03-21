class Query
  include Mongoid::Document
  include Mongoid::Timestamps

  # FIELDS
  field :query, type: String
  field :hit_count, type: Integer, default: 0
  field :total_results, type: Integer
  field :total_pages, type: Integer
  field :page, type: Integer

  # VALIDATIONS

  validates :total_results, presence: true, numericality: { only_integer: true }
  validates :total_pages, presence: true, numericality: { only_integer: true }
  validates :page, presence: true, numericality: { only_integer: true }

  # ASSOCIATIONS
  embeds_many :movies

  # SCOPES
  scope :within_time, -> { where(:created_at.gt => Time.now - 2.minutes) }

  # INSTANCE METHODS

end
