module PaginateResponder
  def to_format
    if get?
      page = @controller.params[:page].to_i || 1
      per  = @controller.params[:per].to_i  || 100
      per  = 100 if per > 100

      @resource = Kaminari.paginate_array @resource if @resource.kind_of? Array
      @resource = @resource.page(page).per(per) if @resource.respond_to? :page

      @controller.headers['X-Total-Count']  = @resource.total_count.to_s
      @controller.headers['X-Pages']    = @resource.total_pages.to_s
      @controller.headers['X-Per-Page'] = per.to_s
      link       = []
      link_next  = "<#{@controller.current_url(page: @resource.next_page)}>; rel=\"next\""
      link_last  = "<#{@controller.current_url(page: @resource.total_pages)}>; rel=\"last\""
      link_prev  = "<#{@controller.current_url(page: @resource.prev_page)}>; rel=\"prev\""
      link_first = "<#{@controller.current_url(page: 1)}>; rel=\"first\""

      link.push(link_prev, link_first) if @resource.prev_page
      link.push(link_next, link_last)  if @resource.next_page

      @controller.headers['Link'] = link.join(', ')
    end
    super
  end
end
