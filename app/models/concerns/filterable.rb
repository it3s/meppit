module Filterable
  extend ActiveSupport::Concern

  included do
    scope :filter, -> (params) do
      queryset_filter = ListFilter.new params
      queryset = where(nil)
      queryset_filter.filter(queryset)
    end
  end
end
