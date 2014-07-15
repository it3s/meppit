module Searchable
  extend ActiveSupport::Concern

  included do
    include PgSearch

    pg_search_scope :search_by_name, against: :name, using: {
      tsearch: {prefix: true},
      trigram: {threshold: 0.2},
    }

  end

  module ClassMethods
    def search_field(field)
      pg_search_scope :"search_by_#{field}", against: field, using: {
        tsearch: {prefix: true},
        trigram: {threshold: 0.2},
      }
    end
  end
end
