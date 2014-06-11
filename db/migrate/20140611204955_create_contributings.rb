class CreateContributings < ActiveRecord::Migration
  def change
    create_table :contributings do |t|
      t.references :contributor, index: true
      t.references :contributable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
