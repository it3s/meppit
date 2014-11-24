class AddMigratedInfoToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :migrated_info, :json
  end
end
