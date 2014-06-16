module Follower
  extend ActiveSupport::Concern

  included do
    has_many :followings, :foreign_key => :follower_id, :dependent => :destroy

    def followed_objects
      followings.map(&:followable)
    end

    def follow?(obj)
      followings.where(followable: obj).exists?
    end
  end
end
