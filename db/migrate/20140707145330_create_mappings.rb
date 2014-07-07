class CreateMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.belongs_to :geo_data, null: false, index: true
      t.belongs_to :map,      null: false, index: true

      t.timestamps
    end
  end
end
