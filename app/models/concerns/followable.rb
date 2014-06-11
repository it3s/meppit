module Followable
  extend ActiveSupport::Concern


  included do
    def followers
      _followers.map(&:follower)
    end

    def followers_count
      _followers.count
    end

    private

    def _followers
      Following.where(followable_type: self.class.name, followable_id: id)
    end
  end
end
