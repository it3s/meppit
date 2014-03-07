class AddAboutMeAndContactsToUser < ActiveRecord::Migration
  def change
    add_column :users, :about_me, :text
    add_column :users, :contacts, :hstore
  end
end
