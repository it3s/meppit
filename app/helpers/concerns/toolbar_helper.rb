module Concerns
  module ToolbarHelper
    extend ActiveSupport::Concern

    def tools_list(obj, only=:all)
      edit_url = url_for([:edit, obj])
      tools = {
        edit: {
          icon:   :pencil,
          title:   t('toolbar.edit'),
          url:     edit_url,
          active?: request.path == edit_url,
        },
        star:     {
          icon:      :star,
          title:     t('toolbar.star'),
          url:       "#",
          active?:   current_user && current_user.follow?(obj),
          component: _follow_component(obj)
        },
        comment:  {icon: :comment,   title: t('toolbar.comment'),  url: ""},
        history:  {icon: :'clock-o', title: t('toolbar.history'),  url: ""},
        settings: {icon: :'cog',     title: t('toolbar.settings'), url: ""},
        flag:     {icon: :flag,      title: t('toolbar.flag'),     url: ""},
        delete:   {icon: :'trash-o', title: t('toolbar.delete'),   url: ""},
      }
      only == :all ? tools.values() : only.map {|name| tools[name] }
    end

    private

    def _follow_component(obj)
      {
        :type => "follow",
        :opts => "data-follow=#{ {
          :follower_id     => current_user.id,
          :followable_id   => obj.id,
          :followable_type => obj.class.name
        }.to_json } "
      }
    end
  end
end

