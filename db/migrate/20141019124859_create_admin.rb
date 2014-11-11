class CreateAdmin < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end
