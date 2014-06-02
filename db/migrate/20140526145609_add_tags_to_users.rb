class AddTagsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :interests, array: true, default: []
    end
    add_index :users, :interests, using: 'gin'
  end
end
