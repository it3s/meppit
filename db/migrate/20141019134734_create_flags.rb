class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.references :user, null: false
      t.string     :reason, null: false
      t.text       :comment
      t.boolean    :solved, null: false, default: false

      t.timestamps
    end
  end
end
