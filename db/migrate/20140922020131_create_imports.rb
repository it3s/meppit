class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string     :source,  null: false
      t.references :user,    null: false, index: true

      t.timestamps
    end
  end
end
