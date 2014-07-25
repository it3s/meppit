# Used with the "versions/version" partial. Ex:
#
#  <%= render 'versions/version', presenter: VersionPresenter.new(object: version, ctx: self) %>
#
#  === Context
#  The `ctx` is the context for the view. It must be given on initialize.
#
class VersionPresenter
  include Presenter

  required_keys :object, :ctx  # ctx is the view context

  def author
    @_user ||= User.find object.whodunnit.to_i
  end

  def author_name
    author.name
  end

  def event
    ctx.t "versions.event.#{object.event}"
  end

  def changes
    object.changeset.keys.to_sentence
  end

  def time
    object.created_at
  end

  def time_ago
    ctx.t('time_ago', time: ctx.time_ago_in_words(time))
  end

  def diff_items
    Hash[*object.changeset.map {|k, v| [k, OpenStruct.new(old_value: v[0], new_value: v[1])]}.flatten]
  end
end

