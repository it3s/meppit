class CreateRelationMetadata < ActiveRecord::Migration
  def change
    create_table :relation_metadata do |t|
      t.references :relation,    index: true
      t.text       :description
      t.date       :start_date
      t.date       :end_date
      t.float      :amount,      precision: 12, scale: 2
      t.string     :currency,    length: 3

      t.timestamps
    end
  end
end
