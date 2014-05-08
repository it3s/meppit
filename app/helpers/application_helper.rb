module ApplicationHelper
  include Concerns::ContactsHelper

  def i18n_language_names
    {
      :en      => 'English',
      :'pt-BR' => 'Português'
    }
  end

  def current_translations
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    @translations ||= I18n.backend.send(:translations)
    (@translations[I18n.locale] || {}).with_indifferent_access
  end

  def javascript_exists?(script)
    script = "#{Rails.root}/app/assets/javascripts/#{script}.js"
    extensions = %w(.coffee .erb .coffee.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || File.exists?("#{script}#{extension}")
    end
  end

  def with_http(url)
    url.starts_with?('http://') ? url : "http://#{url}"
  end

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

    "<a href=\"#{url}\" #{html_attrs} data-components=\"modal\" data-modal='#{ modal_attrs }'>#{body}</a>".html_safe
  end

  def link_to_tooltip(body, selector)
    "<a href=\"#\" data-components=\"tooltip\" data-tooltip='#{ {template: selector}.to_json }'>#{body}</a>".html_safe
  end

  def remote_form_for(record, options={}, &block)
    options.deep_merge!(:remote => true, :html => {'data-components' => 'remoteForm', 'multipart' => true})
    simple_form_for(record, options, &block)
  end


  def tools_list(obj, only=:all)
    tools = {
      :edit     => {:icon => :pencil,        :title => t('toolbar.edit'),     :url => url_for([:edit, obj])},
      :star     => {:icon => :star,          :title => t('toolbar.star'),     :url => ""},
      :comment  => {:icon => :comment,       :title => t('toolbar.comment'),  :url => ""},
      :history  => {:icon => :'clock-o',     :title => t('toolbar.history'),  :url => ""},
      :settings => {:icon => :'cog',         :title => t('toolbar.settings'), :url => ""},
      :flag     => {:icon => :flag,          :title => t('toolbar.flag'),     :url => ""},
      :delete   => {:icon => :'trash-o',     :title => t('toolbar.delete'),   :url => ""},
    }
    only == :all ? tools.values() : only.map {|name| tools[name] }
  end
end
