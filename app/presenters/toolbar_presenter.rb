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
    [:edit, :star, :comment, :history, :settings, :flag, :delete, :featured]
  end

  # Select which tools will be displayed given the current object
  def select_tools
    case type
    when 'user'
      current_user == object ? [:edit, :settings] : [:star, :flag]
    when 'geo_data'
      (current_user ? [:edit] : []) + [:star, :history, :flag] + (can_delete? ? [:delete] : []) +
        (is_admin? ? [:featured] : [])
    when 'map'
      (current_user ? [:edit] : []) + [:star, :history, :flag] + (can_delete? ? [:delete] : []) +
        (is_admin? ? [:featured] : [])
    else
      available_tools
    end
  end

  def can_delete?
    current_user && current_user.admin?
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
    current_user && current_user.admin?
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
      { icon: :flag, title: t('toolbar.flag'), url: ctx.new_flag_path,
        component: _modal_component }
    end

    def _delete_tool
      { icon: :'trash-o', title: t('toolbar.delete'), url: ctx.confirm_deletion_admin_path(current_user),
        component: _modal_component }
    end

    def _featured_tool
      { icon: :'certificate', title: t('toolbar.featured'), url: "#",
        active?: object.try(:featured?),
        component: _featured_component }
    end

    def _follow_component
      opts_json = ctx.follow_options_for object
      {
        type: "follow loginRequired",
        opts: "data-follow-options=#{ opts_json } "
      }
    end

    def _modal_component
      {
        type: "modal loginRequired",
        opts: "data-modal-options=#{ {remote: true, login_required: true}.to_json } "
      }
    end

    def _featured_component
      opts_json = ctx.featured_button_options_for object
      {
        :type => "featuredButton loginRequired",
        :opts => "data-featuredButton-options=#{ opts_json } "
      }
    end

    def _user_id
      ctx.params[:id] || ctx.params[:user_id]
    end
end
