class AddLanguageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :language, :string, :limit => 10
  end
end
