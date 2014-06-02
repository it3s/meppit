class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag, unique: true

      t.timestamps
    end
  end
end
