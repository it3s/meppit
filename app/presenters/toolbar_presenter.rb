# Used with the "shared/toolbar" partial. Ex:
#
#  <%= render 'shared/toolbar', presenter: ToolbarPresenter.new(object: @user, ctx: self) %>
#
#  === Context
#  The `ctx` is the context for the view. It must be given on initialize.
#
class ToolbarPresenter
  include Presenter

  required_keys :object, :ctx  # ctx is the view context

  # User => 'user', GeoData => 'geo_data'
  def type
    object.class.name.underscore
  end

  def available_tools
    [:edit, :star, :comment, :history, :settings, :flag, :delete]
  end

  # Select which tools will be displayed given the current object
  def select_tools
    case type
    when 'user'
      current_user == object ? [:edit, :settings] : [:star, :flag]
    when 'geo_data'
      (current_user ? [:edit] : []) + [:star, :history, :flag, :delete] +
        (is_admin? ? [:feature] : [])
    when 'map'
      (current_user ? [:edit] : []) + [:star, :history, :flag, :delete] +
        (is_admin? ? [:feature] : [])
    else
      available_tools
    end
  end

  # Build a list of OpenStruct with the options for each of the selected tools
  def tools
    select_tools.map { |tool_name| OpenStruct.new(options_for tool_name) }
  end

  # get a options hash for a tool whith `name`
  def options_for(name)
    send :"_#{name}_tool"
  end

  # i18n proxy
  def t(*args)
    ctx.t(args)
  end

  # current user proxy
  def current_user
    ctx.current_user
  end

  def is_admin?
    ctx.is_admin?
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
      history_url = ctx.url_for([object, :history])
      { icon: :'clock-o', title: t('toolbar.history'), url: history_url,
        active?: ctx.request.path == history_url }
    end

    def _settings_tool
      settings_url = ctx.settings_path id: _user_id
      { icon: :'cog', title: t('toolbar.settings'), url: settings_url,
        active?: ctx.request.path == settings_url }
    end

    def _flag_tool
      { icon: :flag, title: t('toolbar.flag'), url: "" }
    end

    def _delete_tool
      { icon: :'trash-o', title: t('toolbar.delete'), url: "" }
    end

    def _feature_tool
      { icon: :'certificate', title: t('toolbar.feature'), url: "#",
        active?: object.is_featured?,
        component: _feature_component }
    end

    def _follow_component
      opts_json = ctx.follow_options_for object
      {
        :type => "follow loginRequired",
        :opts => "data-follow-options=#{ opts_json } "
      }
    end

    def _feature_component
      opts_json = ctx.feature_button_options_for object
      {
        :type => "featureButton loginRequired",
        :opts => "data-featureButton-options=#{ opts_json } "
      }
    end

    def _user_id
      ctx.params[:id] || ctx.params[:user_id]
    end
end
