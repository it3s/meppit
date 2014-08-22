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
    case type
    when :map      then ctx.icon :globe
    when :geo_data then ctx.icon :'map-marker'
    when :user     then ctx.icon :user
    else ctx.icon :question
    end
  end

  def changes
    changeset = object.parameters[:changes]
    changeset.nil? || changeset.empty?  ? "" : changeset.keys.to_sentence
  end

  def headline
    if type == :user
      ctx.link_to(ctx.t("profile"), url, class: "trackable").html_safe
    else
      "#{ctx.t 'activities.changes', changes: changes} #{ctx.link_to name, url, class: "trackable"}".html_safe
    end
  end

  def time
    object.created_at
  end

  def time_ago
    ctx.t('time_ago', time: ctx.time_ago_in_words(time))
  end

  def event
    ctx.t "activities.event.#{object.key.split('.').last}"
  end

end
