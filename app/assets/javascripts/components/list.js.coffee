App.components.list = ->
  attributes: ->
    list:   @container.find("ul.list")
    scroll: @attr.scroll || {}

    infiniteScrollDefaults:
      navSelector:  @container.find("nav.pagination")
      nextSelector: @container.find("nav.pagination a[rel=next]")
      itemSelector: ".list .list-item"
      prefill:      on
      dataType:     "html"

  initialize: ->
    options = @handleOptions()
    @startInfiniteScroll(options)

  handleOptions: ->
    options = _.defaults(@attr.scroll, @attr.infiniteScrollDefaults)
    options.binder ?= container if options['behavior'] is 'local'
    options

  startInfiniteScroll: (opts) ->
    _this = this
    @attr.list.infinitescroll opts, -> _this.startComponents.bind(_this)(this)

  startComponents: (container) ->
    App.mediator.publish('components:start', $(container))
