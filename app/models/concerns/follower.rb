module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, :foreign_key => :follower_id, :dependent => :destroy

    def following(opts={}, order='updated_at DESC')
      followings.order(order).where(opts).includes(:followable).map(&:followable)
    end

    def follow(obj)
      follow = Following.where(followable: obj, follower: self).first_or_create
      follow.save
    end

    def unfollow(obj)
      following = Following.find_by(followable: obj, follower: self)
      following.destroy if following
    end

    def follow?(obj)
      followings.where(followable: obj).exists?
    end
  end
end
