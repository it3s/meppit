class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.references :follower
      t.references :followable, polymorphic: true

      t.timestamps
    end
    add_index :followings, :follower_id
    add_index :followings, [:followable_type, :followable_id]
  end
end
