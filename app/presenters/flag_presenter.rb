class FlagPresenter
  include Presenter

  required_keys :flag, :ctx

  def target
    flag.flaggable
  end

  def name
    target.name
  end

  def url
    ctx.url_for target
  end

  def object_type
    ctx.object_type target
  end

  def avatar
    return ctx.image_tag target.avatar.thumb.url if target.try(:avatar)

    case object_type
    when :map      then ctx.icon :globe
    when :geo_data then ctx.icon :'map-marker'
    when :user     then ctx.icon :user
    else ctx.icon :question
    end
  end

  def time
    flag.created_at
  end

  def time_ago
    ctx.t('time_ago', time: ctx.time_ago_in_words(time))
  end

  def user
    flag.user
  end

  def reason
    ctx.t "flags.reason.#{flag.reason}"
  end

  def comment
    flag.comment
  end

  # def type
  #   flag.solved ? 'solved' : 'unsolved'
  # end
end
