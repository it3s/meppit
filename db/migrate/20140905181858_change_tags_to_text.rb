class ChangeTagsToText < ActiveRecord::Migration
  def up
    change_column :maps,     :tags,      :text, array: true, default: '{}'
    change_column :geo_data, :tags,      :text, array: true, default: '{}'
    change_column :users,    :interests, :text, array: true, default: '{}'
  end

  def down
    change_column :maps,     :tags,      :string, array: true, default: '{}'
    change_column :geo_data, :tags,      :string, array: true, default: '{}'
    change_column :users,    :interests, :string, array: true, default: '{}'
  end
end
