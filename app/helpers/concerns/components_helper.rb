module Concerns
  module ComponentsHelper
    extend ActiveSupport::Concern

    def hash_to_attributes(hash)
      # convert hash to a html attributes string
      #
      # Usage:
      #   => hash_to_attributes({:attr => "val1 val2", :class => "button"})
      #   => "attr=\"val1 val2\" class=\"button\" "
      #
      hash.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
    end

    def link_to_modal(body, url, options={})
      html_attrs = hash_to_attributes(options[:html]) if options[:html]
      modal_attrs = options.except(:html).to_json
      components = ["modal"] + (options[:login_required] ? ["loginRequired"] : [])

      "<a href=\"#{url}\" #{html_attrs} data-components=\"#{ components.join(' ') }\" data-modal='#{ modal_attrs }'>#{body}</a>".html_safe
    end

    def link_to_tooltip(body, selector)
      "<a href=\"#\" data-components=\"tooltip\" data-tooltip='#{ {template: selector}.to_json }'>#{body}</a>".html_safe
    end

    def remote_form_for(record, options={}, &block)
      options.deep_merge!(:remote => true, :html => {'data-components' => 'remoteForm', 'multipart' => true})
      simple_form_for(record, options, &block)
    end

    def tags_input(f, name, tags)
      f.input name, :input_html => {'data-components' => 'tags', 'data-tags' => tags.to_json, 'data-autocomplete' => tag_search_path }
    end

    def autocomplete_field_tag(name, url)
      render('shared/components/autocomplete', name: name, url: url).html_safe
    end

    def additional_info_value(f)
      dict = f.object.additional_info
      (dict && !dict.empty?) ? dict.to_yaml.gsub("---\n", "") : ""
    end

    def additional_info_json(object)
      _hash_with_humanized_keys(object.additional_info).to_json
    end

    def relations_manager_data(object)
      {
        options: object.class.relations_options,
        autocomplete_placeholder: t("components.autocomplete.relation_target"),
        autocomplete_url: search_by_name_geo_data_index_path,
        metadata_title: t("relations.title.metadata"),
        remove_title: t("relations.title.remove"),
      }
    end

    private

    def _hash_with_humanized_keys(hash)
      Hash[hash.map {|k,v| [k.humanize, _nested_hash_value(v)] }]
    end

    def _nested_hash_value(val)
      (val.is_a? Hash) ? _hash_with_humanized_keys(val) : val
    end

  end
end
