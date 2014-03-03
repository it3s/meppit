module ApplicationHelper

  def i18n_language_names
    {
      :en      => 'English',
      :'pt-BR' => 'Português'
    }
  end

  def javascript_exists?(script)
    script = "#{Rails.root}/app/assets/javascripts/#{script}.js"
    extensions = %w(.coffee .erb .coffee.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || File.exists?("#{script}#{extension}")
    end
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

  def remote_form_for(record, options={}, &block)
    options.deep_merge!(:remote => true, :html => {'data-components' => 'remoteForm'})
    simple_form_for(record, options, &block)
  end


  def tools_list(obj, only=:all)
    tools = {
      :edit     => OpenStruct.new(:name => :edit,     :url => url_for([:edit, obj])),
      :star     => OpenStruct.new(:name => :star,     :url => ""),
      :comment  => OpenStruct.new(:name => :comment,  :url => ""),
      :history  => OpenStruct.new(:name => :history,  :url => ""),
      :flag     => OpenStruct.new(:name => :flag,     :url => ""),
      :delete   => OpenStruct.new(:name => :delete,   :url => ""),
      :google   => OpenStruct.new(:name => :google,   :url => ""),
      :facebook => OpenStruct.new(:name => :facebook, :url => ""),
      :twitter  => OpenStruct.new(:name => :twitter,  :url => ""),
    }
    only == :all ? tools.values() : only.map {|name| tools[name] }
  end
end
