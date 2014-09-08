class ActivityPresenter
  include Presenter

  required_keys :object, :ctx

  def trackable
    @trackable ||= object.trackable
  end

  def name
    trackable.try(:name)
  end

  def url
    ctx.url_for trackable
  end

  def type
    ctx.object_type trackable
  end

  def avatar
    return ctx.image_tag trackable.avatar.thumb.url if trackable.try(:avatar?)

    case type
    when :map      then ctx.icon :globe
    when :geo_data then ctx.icon :'map-marker'
    when :user     then ctx.icon :user
    else ctx.icon :question
    end
  end

  def changes
    changeset = object.parameters[:changes]
    if changeset.nil? || changeset.empty?
      ""
    else
      ctx.icon("edit", changeset.keys.to_sentence).html_safe
    end
  end

  def time
    object.created_at
  end

  def time_ago
    ctx.t('time_ago', time: ctx.time_ago_in_words(time))
  end

  def event
    "<span class=\"event-type\">#{ event_type }</span> #{headline}".html_safe
  end

  def event_type
    ctx.t "activities.event.#{object.key.split('.').last}"
  end

  def user_itself?
    type == :user && trackable.id == object.owner.id
  end

  def headline
    text = user_itself? ? ctx.t("profile") : name
    ctx.link_to(text, url, class: "trackable").html_safe
  end
end
