class ListFilter
  extend ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :tags, :tags_type, :sort_by, :order, :visualization

  def initialize(attributes = {})
    attributes.each { |name, value| send "#{name}=", value }
    set_defaults
  end

  def filter(queryset)
    queryset = queryset.with_tags tags unless tags.empty?
    queryset = queryset.order ordering
    queryset
  end

  def persisted?
    false
  end

  def id
    nil
  end

  private

    def set_defaults
      self.tags ||= []
      self.tags_type ||= 'all'
      self.sort_by ||= 'name'
      self.order ||= 'asc'
      self.visualization ||= 'list'
    end

    def ordering
      "#{sort_by} #{order}"
    end
end
