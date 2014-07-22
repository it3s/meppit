class AddAdditionalInfoToGeoData < ActiveRecord::Migration
  def change
    add_column :geo_data, :additional_info, :json
  end
end
