class AddAuthTokenToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :auth_token
    end
    add_index :users, :auth_token
  end
end
