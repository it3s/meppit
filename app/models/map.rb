class Map < ActiveRecord::Base
  include Contacts
  include Taggable
  include Followable
  include Contributable

  has_many :followings, :as => :followable
  has_many :followers, :through => :followings

  has_many :mappings
  has_many :geo_data, through: :mappings

  belongs_to :administrator, class_name: 'User'

  searchable_tags :tags

  validates :name, presence: true
  validates :administrator, presence: true

  def data_count
    geo_data.count
  end

  def location
    return nil if data_count.zero?

    ::GeoJSON.encode_feature_collection geo_data_features
  end

  def geo_data_features
    geo_data.all.map { |data| ::GeoJSON::feature_from_model data if data.location  }
  end

  def location_geojson
    location ? location.to_json : nil
  end
end
