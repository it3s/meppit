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
        # we want activities related to objetcs followed by this user
        # AND activities owned by users followed by this user
        followings[:followable_type].in([activities[:trackable_type], activities[:owner_type]])
      ).where(
          # Activities from objects followed by this user
          Arel::Nodes::Grouping.new(
            activities[:trackable_id].eq(followings[:followable_id]).and(
              activities[:trackable_type].eq(followings[:followable_type])
            )
          ).or(
          # Activities owned by users followed by this user
          Arel::Nodes::Grouping.new(
            activities[:owner_id].eq(followings[:followable_id]).and(
              followings[:followable_type].eq(self.class.name)
            )
          )
        ).and(
          # Only followed by this user
          followings[:follower_id].eq(self.id)
        ).and(
          # But remove activities owned by this user itself
          activities[:owner_type].eq(self.class.name).and(
            activities[:owner_id].not_eq(self.id))
        )
      ).order("activities.created_at desc").project('activities.id')
      # Convert to ActiveRecord Relation
      PublicActivity::Activity.includes(:trackable).where(
        activities[:id].in(sql))
    end
  end
end
