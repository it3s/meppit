class NotificationPresenter
  include Presenter

  required_keys :object, :ctx

  def activity
    @activity ||= ActivityPresenter.new object: object.activity, ctx: ctx
  end

  def author
    @author ||= object.activity.owner
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
end
