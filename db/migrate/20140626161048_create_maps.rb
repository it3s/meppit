class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string   :name,          null: false
      t.text     :description
      t.hstore   :contacts
      t.string   :tags,          array: true, default: []

      t.timestamps
    end

    add_index :maps, :tags,     using: 'gin'
  end
end
