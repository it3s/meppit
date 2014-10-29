class CreateFeatureds < ActiveRecord::Migration
  def change
    create_table :featureds do |t|
      t.references :featurable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
