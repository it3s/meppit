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
      pathParse:    (path) -> path.match(/^(.*?page=)[0-9]+(.*|$)/).slice(1)

  initialize: ->
    options = @handleOptions()
    @startInfiniteScroll(options)
    App.mediator.subscribe "listItem:remove", (evt, data) =>
      @removeItemByInternalId(data.id)

  handleOptions: ->
    options = _.defaults(@attr.scroll, @attr.infiniteScrollDefaults)
    options.binder ?= container if options['behavior'] is 'local'
    options

  getItemByInternalId: (id) ->
    @attr.list.find("[data-listItem-id=#{id}]")

  removeItemByInternalId: (id) ->
    item = @getItemByInternalId id
    item.remove()

  startInfiniteScroll: (opts) ->
    _this = this
    @attr.list.infinitescroll opts, -> _this.startComponents.bind(_this)(this)

  startComponents: (container) ->
    App.mediator.publish('components:start', $(container))
