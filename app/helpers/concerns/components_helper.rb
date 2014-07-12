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
  end
end
