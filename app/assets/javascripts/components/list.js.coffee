App.components.list = (container) ->
  {
    container: container
    list: container.find("ul.list")

    infiniteScrollDefaults:
      navSelector: container.find("nav.pagination")
      nextSelector: container.find("nav.pagination a[rel=next]")
      itemSelector: ".list .list-item"
      prefill: on
      dataType: "html"

    init: ->
      options = @handleOptions()
      @startInfiniteScroll(options)

    handleOptions: ->
      data = @container.data('list') ? {}
      options = _.defaults(data.scroll ? {}, @infiniteScrollDefaults)
      if options['behavior'] is 'local'
        options.binder ?= container
      options

    startComponents: (container) ->
      App.mediator.publish('components:start', $(container))

    startInfiniteScroll: (opts) ->
      _this = this
      @list.infinitescroll opts, () -> _this.startComponents.bind(_this)(this)
  }
