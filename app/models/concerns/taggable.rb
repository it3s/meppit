module Taggable
  extend ActiveSupport::Concern

  module ClassMethods
    def searchable_tags(*fields)
      fields.each do |field|
        after_save { send(field).each { |tag| Tag.build(tag).save } }

        # MyModel.with_tags(['foo', 'bar'], :any)
        scope :"with_#{field}", -> (tags, search_for=:all) {
          operator = search_for == :any ? '&&' : '@>'
          where("#{field} #{operator} ARRAY[?]", tags)
        }
      end
    end
  end
end
