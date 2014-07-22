module Searchable
  extend ActiveSupport::Concern

  included do
    include PgSearch

  end

  module ClassMethods
    def search_fields(opts)
      search_options = Rails.application.config.pg_search_options

      pg_search_scope :"search_by_#{opts[:scoped]}", {against: opts[:scoped]}.merge(search_options)

      multisearchable against: opts[:multi] if opts[:multi]
    end
  end
end
