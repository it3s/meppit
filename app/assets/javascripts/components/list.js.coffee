#= require meppit-map

App.components.list = (container) ->
  {
    container: container
    infiniteScrollDefaults:
      navSelector: "nav.pagination"
      nextSelector: "nav.pagination a[rel=next]"
      itemSelector: ".list .list-item"
      prefill: on

    init: ->
      @handleOptions()
      @startInfiniteScroll()

    handleOptions: ->
      data = @container.data('list') ? {}
      @infiniteScrollOptions = data.scroll ? {}

    startInfiniteScroll: ->
      @infiniteScrollOptions.binder ?= container if @infiniteScrollOptions['behavior'] is 'local'
      @container.find("ul.list").infinitescroll _.defaults(
          @infiniteScrollOptions, @infiniteScrollDefaults)

  }
