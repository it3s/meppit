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

      "<a href=\"#{url}\" #{html_attrs} data-components=\"#{ components.join(' ') }\" data-modal-options='#{ modal_attrs }'>#{body}</a>".html_safe
    end

    def link_to_tooltip(body, selector)
      "<a href=\"#{selector}\" data-components=\"tooltip\" data-tooltip-options='#{ {template: selector}.to_json }'>#{body}</a>".html_safe
    end

    def button_to_modal(body, url, options={})
      html_attrs = hash_to_attributes(options[:html]) if options[:html]
      modal_attrs = options.except(:html).to_json
      components = ["modal"] + (options[:login_required] ? ["loginRequired"] : [])

      "<button data-href=\"#{url}\" #{html_attrs} data-components=\"#{ components.join(' ') }\" data-modal-options='#{ modal_attrs }'>#{body}</button>".html_safe
    end

    def remote_form_for(record, options={}, &block)
      options.deep_merge!(:remote => true, :html => {'data-components' => 'remoteForm', 'multipart' => true})
      simple_form_for(record, options, &block)
    end

    def tags_input(f, name, tags)
      f.input name, :input_html => {'data-components' => 'tags', 'data-tags-options' => {tags: tags, autocomplete: tag_search_path}.to_json }
    end

    def autocomplete_field_tag(name, url)
      render('shared/components/autocomplete', name: name, url: url).html_safe
    end

    def selector_option(label, param, value, default=false, class_name=nil)
      class_name = value unless class_name
      selected = params[param] == value.to_s || (params[param].nil? && default)
      "<a href=\"?#{param}=#{value}\" class=\"option #{class_name}#{' selected' if selected}\" data-selector-param=\"#{param}\" data-selector-value=\"#{value}\" #{'data-selector-default="true"' if default}>#{label}</a>".html_safe

    end

    def additional_info_value(f)
      dict = f.object.additional_info
      (dict && !dict.empty?) ? dict.to_yaml.gsub("---\n", "") : ""
    end

    def additional_info_json(object)
      {jsonData: _hash_with_humanized_keys(object.additional_info)}.to_json
    end

    def relations_manager_data
      {
        options: Relation.options,
        autocomplete_placeholder: t("components.autocomplete.relation_target"),
        autocomplete_url: search_by_name_geo_data_index_path,
        remove_title: t("relations.title.remove"),
        metadata_title: t("relations.metadata.title"),
        start_date_label: t("relations.metadata.start_date"),
        end_date_label: t("relations.metadata.end_date"),
        amount_label: t("relations.metadata.amount"),
      }
    end

    def layers_manager_data
      {
        tags_autocomplete_url: '', #TODO
        remove_title: t("layers.title.remove"),
        data_title: t("layers.title.data"),
        fill_color_title: t("layers.title.fill_color"),
        stroke_color_title: t("layers.title.stroke_color"),
        unnamed_layer: t("layers.unnamed"),
        data_name: t("layers.data.name"),
        data_visible: t("layers.data.visible"),
        data_color: t("layers.data.color"),
        data_tags: t("layers.data.tags"),
      }
    end

    def map_data
      # Data used by map
      data = {
        expand_button_title: t("components.map.expand_button_title"),
        collapse_button_title: t("components.map.collapse_button_title"),
      }
      # Data used by map editor
      data = data.merge({
        geometry_selector_title: t("components.map.geometry_selector.title"),
        geometry_selector_explanation: t("components.map.geometry_selector.explanation"),
        marker_button_title: t("components.map.geometries.marker"),
        shape_button_title: t("components.map.geometries.shape"),
        line_button_title: t("components.map.geometries.line"),
        location_selector_title: t("components.map.location_selector.title"),
        location_selector_question_explanation: t("components.map.location_selector.question_explanation"),
        near_button_title: t("components.map.location_selector.near_button"),
        far_button_title:t("components.map.location_selector.far_button"),
        location_selector_instruction_explanation: t("components.map.location_selector.instruction_explanation"),
      }) if edit_mode?
      data
    end

    def map_options(obj)
      obj_type = object_type obj
      opts = {
        layers: obj.try(:layers_values),
        geojson: obj.location_geohash,
        featuresIds: (obj.try(:geo_data_ids) || obj.id || nil),
        featureURL: "\#{baseURL}#{obj_type}/\#{id}/",
        hasLocation: obj.try(:'has_location?'),
      }
      opts = opts.merge({
        editor: true,
        inputSelector: "##{obj_type}_location"
      }) if edit_mode?
      opts = opts.merge({
        geometryType: 'Point',
        geolocation: true
      }) if obj_type == :user && edit_mode?
      opts
    end

    def show_relation_metadata?(rel)
      !rel[:metadata].empty? && !rel[:metadata].values.all?(&:blank?)
    end

    def currency_symbol(curr)
      case curr
        when 'eur' then icon("euro")
        when 'usd' then icon("dollar")
        when 'brl' then "R$"
        else "$"
      end
    end

    def flag_reason_options
      Flag.reason_choices.map { |reason| [t("flags.reason.#{reason}"), reason] }
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
