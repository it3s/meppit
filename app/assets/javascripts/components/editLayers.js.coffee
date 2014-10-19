DataForm = ->
  template: JST['templates/layerData']

  init: (opts) ->
    @index = opts.index
    @el = $ @template(opts)
    @findFields()
    @status = 'hidden'
    @bindEvents()
    this

  show: ->
    @el.slideDown('fast')
    @status = "active"

  hide: ->
    @el.slideUp('fast')
    @status = "hidden"

  findFields: ->
    @fields = {}
    _.each ['name', 'visible', 'fill_color', 'stroke_color', 'tags'], (key) =>
      @fields[key] = @el.find(".data_#{key}")

  onChange: ->
    App.mediator.publish 'layerData:changed', @index

  getValue: ->
    vals = {}
    _.each @fields, (el, key) -> vals[key] = el.val()
    vals

  setValue: (entry) ->
    _.each ['name', 'visible', 'fill_color', 'stroke_color', 'tags'], (key) =>
        @fields[key].val entry[key]

  bindEvents: ->
    _.each @fields, (el, key) =>
      el.change _.debounce(@onChange.bind(this), 100)


LayerItem = ->
  template: JST['templates/layerItem']

  init: (opts) ->
    @index = opts.index
    @el = $ @template(opts)
    @addDataForm(opts)
    @findElements()
    @bindEvents()
    this

  addDataForm: (opts) ->
    @data =  DataForm().init(opts)
    @el.find('.data-container').append @data.el

  findElements: ->
    @nameEl = @el.find('.layer_name')
    @fillColorEl = @el.find('.layer_fill_color')
    @strokeColorEl = @el.find('.layer_stroke_color')
    @visibleEl   = @el.find('.layer_visible')
    @tagsEl   = @el.find('.layer_tags')
    @idEl     = @el.find('.layer_id')

  onRemove: (evt) ->
    evt.preventDefault()

    @el.fadeOut 200, =>
      App.mediator.publish 'layerItem:removed', @index
      @el.remove()

  getId: ->
    if @idEl.val().length > 0 then @idEl.val() else null

  getValue: ->
    #FIXME
    if @fillColorEl.val().length > 0 && @strokeColorEl.val().length > 0 && @tagsEl.val().length > 0
      {id: @getId(), name: @nameEl.val(), visible: @visibleEl.val(), fillColor: @fillColorEl.val(), strokeColor: @strokeColorEl.val(), tags: @tagsEl.val()}
    else
      null

  setValue: (entry)->
    @nameEl.val(entry.name)
    @visibleEl.val(entry.visible)
    @fillColorEl.val(entry.fillColor)
    @strokeColorEl.val(entry.strokeColor)
    @tagsEl.val(entry.tagsColor)
    @idEl.val(entry.id)
    @metadata.setValue(entry.metadata)

  onChange: ->
    App.mediator.publish 'layerItem:changed' if @getValue()

  dataChanged: (evt, index) ->
    @onChange() if index is @index

  toggleData: (evt)->
    evt.preventDefault()
    if @data.status is 'hidden' then @data.show() else @data.hide()

  bindEvents: ->
    @el.find('.list-item-remove-btn').click @onRemove.bind(this)
    @el.find('.list-item-metadata-btn').click @toggleData.bind(this)

    @nameEl.change @onChange.bind(this)
    @visibleEl.change @onChange.bind(this)
    @fillColorEl.change @onChange.bind(this)
    @strokeColorEl.change @onChange.bind(this)
    @tagsEl.change @onChange.bind(this)

    App.mediator.subscribe 'layerData:changed', @dataChanged.bind(this)


App.components.editLayers = ->
  attributes: ->
    itemsContainer: @container.find('.layers-list')
    addButton     : @container.find('.add-new-btn')
    layersInput   : @container.find('.layers-value')
    items         : []
    counter       : 0

  initialize: ->
    @loadData() if @attr.layersInput.val().length > 0
    @addItem()  # always show an empty new entry
    @listen()

  loadData: ->
    entries = JSON.parse @attr.layersInput.val()
    _.each entries, (entry) =>
      item = @addItem()
      item.setValue(entry)

  addItem: ->
    item = LayerItem().init _.extend({}, @attr.data, {index: @attr.counter++})
    @attr.items.push item
    @attr.itemsContainer.append(item.el)
    App.mediator.publish 'components:start', item.el
    item

  listen: ->
    @on @attr.addButton, 'click', @onAdd
    App.mediator.subscribe 'layerItem:removed', @onRemove.bind(this)
    App.mediator.subscribe 'layerItem:changed', @onChange.bind(this)

  onAdd: (evt) ->
    evt.preventDefault()
    @addItem()

  onRemove: (evt, index) ->
    @attr.items[index] = null
    @onChange()

  onChange: ->
    vals = []
    _.each @attr.items, (item) ->
      vals.push item.getValue() if item && item.getValue()
    @attr.layersInput.val JSON.stringify(vals)
