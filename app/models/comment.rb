class Comment < ActiveRecord::Base
  include Filterable

  scope :by_owner, -> (type, id) { where(content_type: type, content_id: id)  }

  belongs_to :user
  belongs_to :content, polymorphic: true

  validates :user, :content, :comment, presence: true

  default_scope { includes(:user).order('created_at desc') }
end
