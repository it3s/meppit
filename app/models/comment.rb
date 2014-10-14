class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :content, polymorphic: true

  validates :user, :content, :comment, presence: true

  default_scope { includes(:user).order('created_at desc') }
end
