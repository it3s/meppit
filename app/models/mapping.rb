class Mapping < ActiveRecord::Base
  belongs_to :map
  belongs_to :geo_data

  validates :map, presence: true
  validates :geo_data, presence: true

  validates :geo_data, uniqueness: {scope: :map}
end
