class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user,    null: false, index: true
      t.references :content, null: false, index: true, polymorphic: true
      t.text       :comment, null: false

      t.timestamps
    end
  end
end
