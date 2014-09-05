class ChangeTagsToText < ActiveRecord::Migration
  def change
    change_column :maps,     :tags,      :text, array: true, default: []
    change_column :geo_data, :tags,      :text, array: true, default: []
    change_column :users,    :interests, :text, array: true, default: []
  end
end
