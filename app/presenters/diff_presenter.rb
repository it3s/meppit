class DiffPresenter
  include Presenter

  required_keys :items, :ctx

  DIFF_TYPES = {
    name: "string",
    description: "text",
    tags: "tags",
    contacts: "contacts",
    additional_info: "jsontable",
    location: "location",
  }

  def show(key, vals)
    send(:"_#{ DIFF_TYPES[key.to_sym] }_diff", vals).html_safe
  end

  private

    def _string_diff(vals)
      ::Differ.diff_by_word(vals.after, vals.before).format_as(:html)
    end

    def _text_diff(vals)
      ::Differ.diff_by_line(vals.after, vals.before).format_as(:html)
    end

    def _tags_diff(vals)
      all_tags = vals.before + vals.after
      ctx.content_tag :div, class: 'tags' do
        all_tags.uniq.map { |tag| "<span class='tag #{_tag_class tag, vals}'>#{ctx.icon :tag, tag}</span>" }.join.html_safe
      end
    end

    def _contacts_diff(vals)
      all_keys = vals.before.keys + vals.after.keys
      contacts = Hash[*all_keys.map { |key| [key, _contact_value(key, vals).html_safe] }.flatten]
      ctx.render 'shared/contacts/view', object: OpenStruct.new(contacts: contacts)
    end

    def _jsontable_diff(vals)
      ctx.content_tag :div do
        ctx.render 'versions/jsontable_diff', vals: vals
      end
    end

    def _location_diff(vals)
      ctx.content_tag :div do
        ctx.render('versions/location_diff', before: _parse_location(vals, :before),
                                             after: _parse_location(vals, :after) )
      end
    end

    def _contact_value(key, vals)
      return "<ins class='differ'>#{vals.after[key]}</ins>"  if vals.after[key]  && !vals.before[key]
      return "<del class='differ'>#{vals.before[key]}</del>" if vals.before[key] && !vals.after[key]
      return vals.before[key] if vals.before[key] == vals.after[key]
      "<del class='differ'>#{vals.before[key]}</del><ins class='differ'>#{vals.after[key]}</ins>"
    end

    def _tag_class(tag, vals)
      return "ins" if !vals.before.include?(tag)
      return "del" if !vals.after.include?(tag)
      ""
    end

    def _parse_location(vals, value_type)
      _location = vals[value_type]
      ::GeoData.new location: (_location.is_a?(Hash) ? _location["wkt"] : _location)
    end
end
