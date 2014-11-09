class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.string :name
      t.integer :position
      t.boolean :visible
      t.string :fill_color, limit: 10
      t.string :stroke_color, limit: 10
      t.hstore :rule
      t.references :map, index: true

      t.timestamps
    end
  end
end
