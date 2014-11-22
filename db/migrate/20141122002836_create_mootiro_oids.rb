class CreateMootiroOids < ActiveRecord::Migration
  def change
    create_table :mootiro_oids do |t|
      t.string     :oid
      t.references :content, polymorphic: true, index: true
    end
  end
end
