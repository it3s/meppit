class ListFilter
  extend ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :tags, :tags_type, :sort_by, :order, :visualization, :longitude, :latitude, :owner

  def initialize(attributes = {})
    attributes.each { |name, value| send "#{name}=", value }
    set_defaults
  end

  def filter(queryset)
    queryset = filter_by_tags(queryset) unless tags.empty?
    queryset = filter_by_owner(queryset)
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

  def owner_type
    owner.split('#')[0]
  end

  def owner_id
    owner.split('#')[1]
  end

  protected

    def filter_by_tags(queryset)
      queryset = queryset.with_tags(tags, tags_type.to_sym) if queryset.respond_to?(:with_tags)
      queryset
    end

    def filter_by_owner(queryset)
      queryset = queryset.by_owner(owner_type, owner_id) if queryset.respond_to?(:by_owner)
      queryset
    end

    def sort(queryset)
      if sort_by == 'location'
        if queryset.respond_to?(:nearest)
          queryset = queryset.nearest(longitude, latitude)
        else
          # sort by name if the queryset doesn't support sort by location
          queryset = queryset.order "name #{order}"
        end
      elsif queryset.klass.columns_hash.keys.include?(sort_by)
        queryset = queryset.order "#{sort_by} #{order}"
      end
      queryset
    end

  private

    def set_defaults
      self.tags ||= []
      self.tags_type ||= 'all'
      self.sort_by ||= 'name'
      self.order ||= 'asc'
      self.visualization ||= 'list'
    end

end
