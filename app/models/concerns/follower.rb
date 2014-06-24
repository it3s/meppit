module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, :foreign_key => :follower_id, :dependent => :destroy

    def followed_objects
      followings.map(&:followable)
    end

    def follow(obj)
      Following.create :followable_type => obj.class.name, :followable_id => obj.id, :follower => self
    end

    def unfollow(obj)
      following = Following.find_by(:followable_type => obj.class.name, :followable_id => obj.id, :follower => self)
      following.destroy if following
    end

    def follow?(obj)
      followings.where(followable: obj).exists?
    end
  end
end
