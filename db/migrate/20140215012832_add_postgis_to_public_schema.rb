class AddPostgisToPublicSchema < ActiveRecord::Migration
  execute "CREATE EXTENSION postgis;"
end
