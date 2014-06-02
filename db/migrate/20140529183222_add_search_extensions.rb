class AddSearchExtensions < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION pg_trgm;'
    execute 'CREATE EXTENSION fuzzystrmatch;'
  end

  def down
    execute 'DROP EXTENSION pg_trgm;'
    execute 'DROP EXTENSION fuzzystrmatch;'
  end
end
