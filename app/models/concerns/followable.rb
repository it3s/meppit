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

    private

    def _followable_params
      {followable_type: self.class.name, followable_id: self.id}
    end

    def _followings
      Following.where(_followable_params)
    end

    def clean_followings_for_destroyed_followable!
      _followings.each { |f| f.destroy }
    end
  end
end
