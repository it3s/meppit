class NotificationPresenter
  include Presenter

  required_keys :object, :ctx

  def activity
    @activity ||= object.activity
  end

  def trackable
    @trackable ||= activity.trackable
  end

  def author
    @author ||= activity.owner
  end

  def name
    type == :user ? ctx.t("profile") : trackable.name
  end

  def id
    object.id
  end

  def url
    ctx.url_for trackable
  end

  def type
    ctx.object_type trackable
  end

  def avatar
    return ctx.image_tag trackable.avatar.thumb.url if trackable.try(:avatar)

    case type
    when :map      then ctx.icon :globe
    when :geo_data then ctx.icon :'map-marker'
    when :user     then ctx.icon :user
    else ctx.icon :question
    end
  end

  def time
    object.created_at
  end

  def time_ago
    ctx.t('time_ago', time: ctx.time_ago_in_words(time))
  end

  def changes
    changeset = activity.parameters[:changes]
    if changeset.nil? || changeset.empty?
      ""
    else
      ctx.icon("edit", changeset.keys.to_sentence).html_safe
    end
  end

  def status
    object.status
  end

  def event_type
    ctx.t "activities.event.#{activity.key.split('.').last}"
  end

end
