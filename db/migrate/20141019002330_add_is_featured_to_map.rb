class AddIsFeaturedToMap < ActiveRecord::Migration
  def change
    add_column :maps, :is_featured, :boolean, default:false, null: false
    add_index :maps, :is_featured
  end
end
