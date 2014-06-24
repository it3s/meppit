module Concerns
  module ListsHelper
    extend ActiveSupport::Concern

    def list_item_controls_for(obj, ctx, type, size)
      size ||= :big
      if type == :follow_button
        return render 'shared/follow_button', object: obj
      else
        return render 'shared/counters',
          presenter: CountersPresenter.new(object: obj, ctx: ctx, size: (size == :small ? :small : :medium))
      end
    end

    def list_item_avatar_for(obj)
      type = object_type obj
      if obj.try(:avatar)
        image_tag obj.avatar.thumb.url
      else
        if type == :map
          icon :globe
        elsif type == :data
          icon :'map-marker'
        elsif type == :user
          icon :user
        else
         icon :question
        end
      end
    end
  end
end
