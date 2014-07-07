class AddAdministratorToMaps < ActiveRecord::Migration
  def change
    add_reference :maps, :administrator, null: false, index: true
  end
end
