App.components.list = ->
  attributes: ->
    list:         @container.find("ul.list")
    itemSelector: ".list-item"
    itemsChecked: '.list-item input[type=checkbox]:checked'
    scroll:       @attr.scroll || {}
    count:        @container.find('.selected-count')

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
    @bindEvents()

  bindEvents: ->
    App.mediator.subscribe "list:selectAll", (evt, data) =>
      @selectAll()

    App.mediator.subscribe "list:unselectAll", (evt, data) =>
      @unselectAll()

    App.mediator.subscribe "list:remove", (evt, data) =>
      @removeItemByInternalId(data.id)
    @bindItemsEvents(@container)

  handleOptions: ->
    options = _.defaults(@attr.scroll, @attr.infiniteScrollDefaults)
    options.binder ?= container if options['behavior'] is 'local'
    options

  getItemByInternalId: (id) ->
    @attr.list.find("[data-listItem-id=#{id}]")

  removeItemByInternalId: (id) ->
    item = @getItemByInternalId id
    item.remove()

  selectAll: ->
    @container.find("#{@attr.itemSelector} input[type=checkbox]").prop 'checked', true
    @updateSelectCount()
    App.mediator.publish "list:selectedAll", {count: $(@attr.itemsChecked).length}

  unselectAll: ->
    @container.find("#{@attr.itemSelector} input[type=checkbox]").prop 'checked', false
    @updateSelectCount()
    App.mediator.publish "list:unselectedAll"

  startInfiniteScroll: (opts) ->
    _this = this
    @attr.list.infinitescroll opts, ->
      _this.bindItemsEvents.bind(_this)(this)
      _this.startComponents.bind(_this)(this)

  bindItemsEvents: (container) ->
    _this = this
    $(container).find("#{@attr.itemSelector} input[type=checkbox]").change ->
      _this.updateSelectCount()
      parent = $(this).parents("li:first")
      isChecked = $(this).is(":checked")
      App.mediator.publish "listItem:#{ ( if isChecked then "selected" else "unselected") }",
        {el: parent, identifier: _this.identifier, listItemId: parent.data("listItem-id")}

  startComponents: (container) ->
    App.mediator.publish('components:start', $(container))

  updateSelectCount: ->
    count = $(@attr.itemsChecked).length
    @attr.count.text if count > 0 then I18n.pluralize(I18n.lists.selected, count) else ""
