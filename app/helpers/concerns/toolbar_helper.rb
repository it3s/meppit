module Concerns
  module ToolbarHelper
    extend ActiveSupport::Concern

    def tools_list(obj, only=:all)
      tools = {}
      [:edit, :star, :comment, :history, :settings, :flag, :delete].each do |name|
        tools[name] = send :"_#{name}_tool", obj
      end
      only == :all ? tools.values() : only.map {|name| tools[name] }
    end

    private

    def _edit_tool(obj)
      edit_url = url_for([:edit, obj])
      { icon: :pencil, title: t('toolbar.edit'), url: edit_url,
        active?: request.path == edit_url }
    end

    def _star_tool(obj)
      { icon: :star, title: t('toolbar.star'), url: "#",
        active?: current_user && current_user.follow?(obj),
        component: _follow_component(obj) }
    end

    def _comment_tool(obj)
      { icon: :comment, title: t('toolbar.comment'), url: "" }
    end

    def _history_tool(obj)
      { icon: :'clock-o', title: t('toolbar.history'), url: "" }
    end

    def _settings_tool(obj)
      { icon: :'cog', title: t('toolbar.settings'), url: "" }
    end

    def _flag_tool(obj)
      { icon: :flag, title: t('toolbar.flag'), url: "" }
    end

    def _delete_tool(obj)
      { icon: :'trash-o', title: t('toolbar.delete'), url: "" }
    end

    def _follow_component(obj)
      {
        :type => "follow",
        :opts => "data-follow=#{ {
          :url             => following_path,
          :data            => {
            :follower_id     => current_user.id,
            :followable_id   => obj.id,
            :followable_type => obj.class.name
          }
        }.to_json } "
      }
    end
  end
end

