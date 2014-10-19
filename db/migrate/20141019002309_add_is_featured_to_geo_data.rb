class AddIsFeaturedToGeoData < ActiveRecord::Migration
  def change
    add_column :geo_data, :is_featured, :boolean, default: false, null: false
    add_index :geo_data, :is_featured
  end
end
