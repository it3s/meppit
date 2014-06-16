module ApplicationHelper
  include Concerns::ContactsHelper
  include Concerns::I18nHelper
  include Concerns::ToolbarHelper

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

  def tags_input(f, name, tags)
    f.input name, :input_html => {'data-components' => 'tags', 'data-tags' => tags.to_json, 'data-autocomplete' => tag_search_path }
  end

  def counters_list(obj, only=:all)
    counters = {
      :data         => { :icon => :'map-marker', :string => 'counters.data',         :method => :data_count,         :class => "data-counter",         :url => "" },
      :maps         => { :icon => :globe,        :string => 'counters.maps',         :method => :maps_count,         :class => "maps-counter",         :url => "" },
      :followers    => { :icon => :star,         :string => 'counters.followers',    :method => :followers_count,    :class => "followers-counter",    :url => "" },
      :contributors => { :icon => :users,        :string => 'counters.contributors', :method => :contributors_count, :class => "contributors-counter", :url => "" },
    }
    available_counters = counters.select {|key, counter| obj.respond_to? counter[:method] }
    only == :all ? available_counters.values() : only.map {|name| available_counters[name] }
  end

  def contributions_list(obj)
    #TODO: get real objects
    list = [
      GeoData.find(1),
      GeoData.find(1),
      User.find(2),
      GeoData.find(1),
      User.find(2),
      GeoData.find(1),
      GeoData.find(1),
      GeoData.find(1),
      GeoData.find(1),
      GeoData.find(1),
      User.find(2),
      GeoData.find(1)
    ]
    Kaminari.paginate_array(list).page(params[:page]).per(5)
  end

  def object_type(obj)
    if obj.kind_of? User
      :user
    elsif obj.kind_of? GeoData
      :data
    #elsif obj.kind_of? Map
      #:map
    else
      :unknown
    end
  end
end
