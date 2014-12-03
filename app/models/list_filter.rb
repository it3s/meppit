class ListFilter
  extend ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :tags, :tags_type, :sort_by, :order, :visualization, :longitude, :latitude

  def initialize(attributes = {})
    attributes.each { |name, value| send "#{name}=", value }
    set_defaults
  end

  def filter(queryset)
    queryset = queryset.with_tags(tags, tags_type.to_sym) unless tags.empty?
    queryset = sort queryset
    queryset
  end

  def persisted?
    false
  end

  def id
    nil
  end

  def checked? (field, val)
    val == send(field)
  end

  def map?
    visualization == 'map'
  end

  private

    def set_defaults
      self.tags ||= []
      self.tags_type ||= 'all'
      self.sort_by ||= 'name'
      self.order ||= 'asc'
      self.visualization ||= 'list'
    end

    def sort(queryset)
      _sort_by = sort_by
      if _sort_by == 'location'
        if queryset.respond_to?(:nearest)
          queryset = queryset.nearest(longitude, latitude)
        else
          _sort_by = 'name'
        end
      else
        queryset = queryset.order "#{_sort_by} #{order}"
      end
      queryset
    end

end
