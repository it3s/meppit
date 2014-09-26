class AddMailNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_notifications, :string, default: 'daily'
  end
end
