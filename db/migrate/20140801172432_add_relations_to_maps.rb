class AddRelationsToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :relations, :json
  end
end
