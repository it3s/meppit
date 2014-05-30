module Taggable
  extend ActiveSupport::Concern

  module ClassMethods
    def searchable_tags(*fields)
      fields.each do |field|
        after_save { send(field).each { |tag| Tag.build(tag).save } }
      end
    end
  end
end
