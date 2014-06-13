module Followable
  extend ActiveSupport::Concern

  included do
    after_destroy :clean_followings_for_destroyed_followable!

    def followers
      _followings.map(&:follower)
    end

    def followers_count
      _followings.count
    end

    private

    def _followings
      Following.where(followable_type: self.class.name, followable_id: id)
    end

    def clean_followings_for_destroyed_followable!
      _followings.each { |f| f.destroy }
    end
  end
end
