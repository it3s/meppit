module Taggable
  extend ActiveSupport::Concern

  module ClassMethods
    def searchable_tags(*fields)
      fields.each do |field|
        after_save { send(field).each { |tag| Tag.build(tag).save } }

        # MyModel.with_tags(['foo', 'bar'], :any)
        scope :"with_#{field}", -> (tags, search_for=:all) {
          if search_for == :any
            where('tags && ARRAY[?]', tags)
          else
            where('tags @> ARRAY[?]', tags)
          end
        }
      end
    end
  end
end
