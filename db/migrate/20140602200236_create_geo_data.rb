class CreateGeoData < ActiveRecord::Migration
  def change
    create_table :geo_data do |t|
      t.string   :name,          null: false
      t.text     :description
      t.hstore   :contacts
      t.string   :tags,          array: true, default: []
      t.geometry :location,      srid: 4326

      t.timestamps
    end

    add_index :geo_data, :tags,     using: 'gin'
    add_index :geo_data, :location, spatial: true
  end
end
