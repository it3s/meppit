class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,             :null => false
      t.string :email,            :null => false
      t.string :crypted_password, :null => true  # must be true for external providers

      t.timestamps
    end

    add_index :users, :email, :unique => true
  end
end
