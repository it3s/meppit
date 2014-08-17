module Followable
  extend ActiveSupport::Concern

  included do
    has_many :followings, :as => :followable
    has_many :followers, :through => :followings

    after_destroy :clean_followings_for_destroyed_followable!

    def followers
      User.joins(:followings).where(followings: _followable_params)
    end

    def followers_count
      followers.count
    end

    def add_follower(follower)
      follow = Following.where(_followable_params.merge follower: follower).first_or_create
      follow.save
    end

    def remove_follower(follower)
      follow = Following.find_by(_followable_params.merge follower: follower)
      follow.destroy if follow
    end

    private

      def _followable_params
        {followable: self}
      end

      def clean_followings_for_destroyed_followable!
        Following.where(_followable_params).destroy_all
      end
  end
end
