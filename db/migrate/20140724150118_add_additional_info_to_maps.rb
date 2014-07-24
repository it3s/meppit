class AddAdditionalInfoToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :additional_info, :json
  end
end
