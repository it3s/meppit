class AddRelationsToGeoData < ActiveRecord::Migration
  def change
    add_column :geo_data, :relations, :json
  end
end
