module Followable
  extend ActiveSupport::Concern

  included do
    after_destroy :clean_followings_for_destroyed_followable!

    def followers
      User.joins(:followings).where(followings: _followable_params)
    end

    def followers_count
      followers.count
    end

    def add_follower(follower)
      follow = Following.where(_contributable_params.merge follower_id: follower.id).first_or_create
      follow.save
    end

    private

    def _followable_params
      {followable_type: self.class.name, followable_id: self.id}
    end

    def clean_followings_for_destroyed_followable!
      Following.where(_followable_params).destroy_all
    end
  end
end
