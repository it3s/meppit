class DiffPresenter
  include Presenter

  required_keys :items, :ctx

  DIFF_TYPES = {
    name: "string",
    description: "text",
    tags: "tags",
    contacts: "hash",
  }

  def show(key, vals)
    send(:"_#{ DIFF_TYPES[key.to_sym] }_diff", vals)
  end

  private

  def _string_diff(vals)
    ::Differ.diff_by_word(vals.new_value, vals.old_value).format_as(:html).html_safe
  end

  def _text_diff(vals)
    ::Differ.diff_by_line(vals.new_value, vals.old_value).format_as(:html).html_safe
  end

  def _tags_diff(vals)
    removed = vals.old_value - vals.new_value
    added = vals.new_value - vals.old_value

    tags = (vals.old_value + vals.new_value).uniq.map { |tag|
      _class = _tag_class tag, added, removed
      "<span class=\"tag #{_class}\">#{ ctx.icon :tag, tag }</span>"
    }.join

    "<div class=\"tags\">#{tags}</div>".html_safe
  end

  def _hash_diff(vals)
    "#{vals.old_value} -->  #{vals.new_value}"
  end

  def _tag_class(tag, added, removed)
    if added.include? tag
      "ins"
    elsif removed.include? tag
      "del"
    else
      ""
    end
  end
end
