class AddPostgisToPublicSchema < ActiveRecord::Migration
  execute "CREATE EXTENSION IF NOT EXISTS postgis;"
end
