class AddHstore < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS hstore'
  end

  def down
    execute 'DROP EXTENSION hstore'
  end
end
