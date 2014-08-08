class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.text   :related_ids, null: false, array: true, default: []
      t.string :rel_type   , null: false
      t.string :direction  , null: false

      t.timestamps
    end

    add_index :relations, :related_ids, using: :gin
  end
end
