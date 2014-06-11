class Following < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followable, polymorphic: true
end
