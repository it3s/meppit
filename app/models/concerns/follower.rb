
module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, :foreign_key => :follower_id

    def followed_objects
      followings.map(&:followable)
    end

    def followers
      Following.where(followable_type: 'User', followable_id: id).map(&:follower)
    end
  end
end
