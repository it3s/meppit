class ListItemPresenter
  include Presenter

  required_keys :object, :ctx

  def size_
    if @size && !@size.blank? then @size else :big end
  end

  def control_type_
    @control_type || :counters
  end

  def checkbox?
    @checkbox || false
  end

  def class_name
    "#{ctx.object_type(object)} #{size_}"
  end

  def id
    object.id
  end

  def identifier
    ctx.identifier_for object
  end

  def title
    ctx.truncate ctx.strip_tags(object.try(:name)), length: (size_ == :small ? 55 : 85)
  end

  def description
    ctx.truncate(ctx.strip_tags(object.try(:description) || object.try(:about_me)), length: (size_ == :small ? 130 : 300))
  end

  def name
    object.try(:name)
  end

  def url
    ctx.url_for object
  end

  def tags
    if size_ == :big and object.respond_to? :tags
      ctx.render 'shared/tags', tags: object.tags, object: object
    end
  end

  def controls
    case control_type_
    when :follow_button
      return ctx.render 'shared/follow_button', object: object unless object == ctx.current_user
    when :remove_button
      return ctx.render 'shared/remove_button', object: object, parent: parent if parent
    else
      return ctx.render 'shared/counters',
        presenter: CountersPresenter.new(object: object, ctx: ctx, size: (size_ == :small ? :small : :medium))
    end
  end

  def avatar
    if object.try(:avatar)
      ctx.image_tag object.avatar.thumb.url
    else
      case ctx.object_type object
      when :map
        ctx.icon :globe
      when :geo_data
        ctx.icon :'map-marker'
      when :user
        ctx.icon :user
      else
       ctx.icon :question
      end
    end
  end
end
