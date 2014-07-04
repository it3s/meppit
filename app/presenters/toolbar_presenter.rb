class ToolbarPresenter
  include Presenter

  required_keys :object, :ctx  # ctx is the view context

  def type
    object.class.name.underscore
  end

  def all_tools
    [:edit, :star, :comment, :history, :settings, :flag, :delete]
  end

  def select_tools
    case type
    when 'user'
      current_user == object ? [:edit, :settings] : [:star, :flag]
    when 'geo_data'
      (current_user ? [:edit] : []) + [:star, :history, :flag, :delete]
    else
      all_tools
    end
  end

  def tools
    select_tools.map { |tool_name| OpenStruct.new(options_for tool_name) }
  end

  def options_for(name)
    send :"_#{name}_tool"
  end

  def t(*args)
    ctx.t(args)
  end

  def current_user
    ctx.current_user
  end

  private

  def _edit_tool
    edit_url = ctx.url_for([:edit, object])
    { icon: :pencil, title: t('toolbar.edit'), url: edit_url,
      active?: ctx.request.path == edit_url }
  end

  def _star_tool
    { icon: :star, title: t('toolbar.star'), url: "#",
      active?: current_user && current_user.follow?(object),
      component: _follow_component }
  end

  def _comment_tool
    { icon: :comment, title: t('toolbar.comment'), url: "" }
  end

  def _history_tool
    { icon: :'clock-o', title: t('toolbar.history'), url: "" }
  end

  def _settings_tool
    { icon: :'cog', title: t('toolbar.settings'), url: "" }
  end

  def _flag_tool
    { icon: :flag, title: t('toolbar.flag'), url: "" }
  end

  def _delete_tool
    { icon: :'trash-o', title: t('toolbar.delete'), url: "" }
  end

  def _follow_component
    opts_json = {:url => ctx.url_for([object, :following])}.to_json
    {
      :type => "follow",
      :opts => "data-follow=#{ opts_json } "
    }
  end
end
