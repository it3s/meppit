class Layer < ActiveRecord::Base
  belongs_to :map

  validates :map_id, :name, :rule, presence: true
end
