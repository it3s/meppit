class AddFlaggableToFlags < ActiveRecord::Migration
  def change
    change_table :flags do |t|
      t.references :flaggable, polymorphic: true, index: true
    end
  end
end
