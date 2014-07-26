class DiffPresenter
  include Presenter

  required_keys :items, :ctx

  DIFF_TYPES = {
    name: "string",
    description: "text",
    tags: "tags",
    contacts: "contacts",
    additional_info: "jsontable",
  }

  def show(key, vals)
    send(:"_#{ DIFF_TYPES[key.to_sym] }_diff", vals).html_safe
  end

  private

  def _string_diff(vals)
    ::Differ.diff_by_word(vals.new_value, vals.old_value).format_as(:html)
  end

  def _text_diff(vals)
    ::Differ.diff_by_line(vals.new_value, vals.old_value).format_as(:html)
  end

  def _tags_diff(vals)
    all_tags = vals.old_value + vals.new_value
    ctx.content_tag :div, class: 'tags' do
      all_tags.uniq.map { |tag| "<span class='tag #{_tag_class tag, vals}'>#{ctx.icon :tag, tag}</span>" }.join.html_safe
    end
  end

  def _jsontable_diff(vals)
    ctx.content_tag :div do
      ctx.render 'versions/jsontable_diff', vals: vals
    end
  end

  def _contacts_diff(vals)
    all_keys = vals.old_value.keys + vals.new_value.keys
    contacts = Hash[*all_keys.map { |key| [key, _contact_value(key, vals).html_safe] }.flatten]
    ctx.render 'shared/contacts/view', object: OpenStruct.new(contacts: contacts)
  end

  def _contact_value(key, vals)
    return "<ins class='differ'>#{vals.new_value[key]}</ins>" if vals.new_value[key] && !vals.old_value[key]
    return "<del class='differ'>#{vals.old_value[key]}</del>" if vals.old_value[key] && !vals.new_value[key]
    return vals.old_value[key] if vals.old_value[key] == vals.new_value[key]
    "<del class='differ'>#{vals.old_value[key]}</del><ins class='differ'>#{vals.new_value[key]}</ins>"
  end

  def _tag_class(tag, vals)
    return "ins" if !vals.old_value.include?(tag)
    return "del" if !vals.new_value.include?(tag)
    ""
  end
end
