module FilterResponder
  def to_format
    if get? && is_filterable?
      @resource = @resource.filter(filter_params)
    end
    super
  end

  private

    def filter_params
      @filter_params  = {
        'tags' => @controller.params.fetch('tags', ''),
        'tags_type' => @controller.params.fetch('tags_type', 'all'),
        'sort_by' => @controller.params.fetch('sort', 'name'),
        'order' => @controller.params.fetch('order', 'asc'),
      }
      @filter_params['tags'] = @filter_params['tags'].split(',')
      @filter_params
    end

    def is_filterable?
      @resource.respond_to?(:filter)
    end
end
