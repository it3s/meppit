class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user,     null: false, index: true
      t.references :activity, null: false
      t.string     :status,   null: false, default: 'unread'

      t.timestamps
    end
  end
end
