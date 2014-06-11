App.components.list = (container) ->
  {
    container: container
    list: container.find("ul.list")

    infiniteScrollDefaults:
      navSelector: "nav.pagination"
      nextSelector: "nav.pagination a[rel=next]"
      itemSelector: ".list .list-item"
      prefill: on
      dataType: "html"

    init: ->
      @handleOptions()
      @startInfiniteScroll(@infiniteScrollOptions)

    handleOptions: ->
      data = @container.data('list') ? {}
      @infiniteScrollOptions = _.defaults(data.scroll ? {}, @infiniteScrollDefaults)
      if @infiniteScrollOptions['behavior'] is 'local'
        @infiniteScrollOptions.binder ?= container

    startInfiniteScroll: (opts) ->
      @list.infinitescroll opts
  }
