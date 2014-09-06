class ListFilter
  extend ActiveModel::Model

  attr_accessor :tags, :sort_by, :order, :visualization

  def initialize(attributes = {})
    attributes.each { |name, value| send "#{name}=", value }
    set_defaults
  end

  def ordering
    "#{sort_by} #{order}"
  end

  def filter(queryset)
    queryset = queryset.with_tags tags unless tags.empty?
    queryset = queryset.order ordering
    queryset
  end

  private

    def set_defaults
      self.tags    ||= []
      self.sort_by ||= 'name'
      self.order   ||= 'asc'
      self.visualization ||= 'list'
    end

end
