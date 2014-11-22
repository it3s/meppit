class CreateMootiroOids < ActiveRecord::Migration
  def change
    create_table :mootiro_oids do |t|
      t.string     :oid, index: true
      t.references :content, polymorphic: true, index: true
    end
  end
end
