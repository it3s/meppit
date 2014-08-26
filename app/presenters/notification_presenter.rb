class NotificationPresenter
  include Presenter

  required_keys :object, :ctx

  def activity
    @activity ||= ActivityPresenter.new object: object.activity, ctx: ctx
  end

  def author
    @author ||= object.activity.owner
  end

  def avatar
    if its_you?
      author.try(:avatar) ? ctx.image_tag(author.avatar.thumb.url) : ctx.icon(:user)
    else
      activity.avatar
    end
  end

  def name
    if activity.type == :user
      activity.trackable.id == ctx.current_user.id ? ctx.t('you') : ctx.t("profile")
    else
      activity.name
    end
  end

  def id
    object.id
  end

  def status
    object.status
  end

  def its_you?
    activity.type == :user && activity.trackable.id == ctx.current_user.id
  end
end
