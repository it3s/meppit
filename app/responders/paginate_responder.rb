module PaginateResponder
  def to_format
    if get? && is_paginable?
      paginate
      set_headers
    end
    super
  end

  private

    def is_paginable?
      @resource.kind_of?(Array) || @resource.respond_to?(:page)
    end

    def set_headers
      link       = []
      link_next  = "<#{@controller.current_url(page: @resource.next_page)}>; rel=\"next\""
      link_last  = "<#{@controller.current_url(page: @resource.total_pages)}>; rel=\"last\""
      link_prev  = "<#{@controller.current_url(page: @resource.prev_page)}>; rel=\"prev\""
      link_first = "<#{@controller.current_url(page: 1)}>; rel=\"first\""

      link.push(link_prev, link_first) if @resource.prev_page
      link.push(link_next, link_last)  if @resource.next_page

      @controller.headers['Link'] = link.join(', ') if link
      @controller.headers['X-Total-Count']  = @resource.total_count.to_s
      @controller.headers['X-Pages']    = @resource.total_pages.to_s
      @controller.headers['X-Per-Page'] = @_per.to_s
      @controller.headers['X-Page'] = @_page.to_s
    end

    def paginate
      @_page = @controller.params[:page].to_i || 1
      @_per  = @controller.params[:per].to_i  || 100
      @_per  = 100 if @_per > 100  # clients cannot get more than 100 objects per request

      @resource = Kaminari.paginate_array @resource if @resource.kind_of? Array
      @resource = @resource.page(@_page).per(@_per) if @resource.respond_to? :page
    end
end
