class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string   :name,          null: false
      t.text     :description
      t.hstore   :contacts
      t.string   :tags,          array: true, default: []
      t.geometry :location,      srid: 4326

      t.timestamps
    end

    add_index :maps, :tags,     using: 'gin'
    add_index :maps, :location, spatial: true
  end
end
