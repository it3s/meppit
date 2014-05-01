class AddLocationToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.geometry :location, :srid => 4326

      t.index :location, :spatial => true
    end
  end
end
