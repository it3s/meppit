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

    def following_activities
      activities = PublicActivity::Activity.arel_table
      followings = Following.arel_table
      sql = activities.join(followings).on(
        followings[:followable_type].eq(activities[:trackable_type])
      ).where(
        activities[:trackable_id].eq(followings[:followable_id]).and(
          followings[:follower_id].eq(self.id)
        #).and(
        #  activities[:owner_type].eq(self.class.name).and(
        #    activities[:owner_id].not_eq(self.id))
        )
      ).order("activities.created_at desc").project('activities.*')
      PublicActivity::Activity.find_by_sql(sql)
    end
  end
end
