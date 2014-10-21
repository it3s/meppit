DataForm = ->
  template: JST['templates/layerData']
  _params: ['name', 'visible', 'fill_color', 'stroke_color', 'rule']

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

  _getRule: ->
    tags = @fields['tags'].val()
    if tags.length > 0
      {
        operator: 'has'
        property: 'tags'
        value: tags.split(',')
      }
    else
      null

  _setRule: (rule) ->
    if rule? and rule.operator == 'has' and rule.property == 'tags' and rule.value?
      value = JSON.parse(rule.value).join(',')
      @fields['tags'].setComponentValue('tags', value)

  getValue: ->
    vals = {}
    _.each @_params, (key) =>
      if key == 'rule'
        vals['rule'] = @_getRule()
      else if @fields[key].attr('type') is 'checkbox'
        vals[key] = @fields[key].prop('checked')
      else
        vals[key] = @fields[key].val()
    vals

  setValue: (entry) ->
    _.each @_params, (key) =>
      if key == 'rule'
        return @_setRule(entry[key])
      else if @fields[key].attr('type') is 'checkbox'
        @fields[key].prop('checked', entry[key])
      else
        @fields[key].val(entry[key])
      @fields[key].setComponentValue(entry[key])

  bindEvents: ->
    _.each @fields, (el, key) =>
      el.change _.debounce(@onChange.bind(this), 100)


LayerItem = ->
  template: JST['templates/layerItem']

  init: (@opts) ->
    @index = @opts.index
    @el = $ @template(@opts)
    @addDataForm(@opts)
    @findElements()
    @bindEvents()
    @update()
    this

  addDataForm: (opts) ->
    @data =  DataForm().init(opts)
    @el.find('.data-container').append @data.el

  findElements: ->
    @namePreviewEl = @el.find('.layer-name-preview')
    @idEl = @el.find('.layer_id')
    @colorPreviewEl = @el.find('.layer-color-preview')

  onRemove: (evt) ->
    evt.preventDefault()

    @el.fadeOut 200, =>
      App.mediator.publish 'layerItem:removed', @index
      @el.remove()

  getId: ->
    if @idEl.val().length > 0 then @idEl.val() else null

  getPosition: ->
    @el.index()

  getValue: ->
    dataValue = @data.getValue()
    _.extend {id: @getId(), position: @getPosition()}, dataValue

  validateValue: ->
    value = @getValue()
    value.name.length > 0 && value.rule?

  setValue: (entry)->
    @idEl.val(entry.id)
    @data.setValue(
      name: _.result entry, 'name'
      visible: _.result entry, 'visible'
      fill_color: _.result entry, 'fill_color'
      stroke_color: _.result entry, 'stroke_color'
      rule: _.result entry, 'rule'
    )
    @update()

  update: ->
    value = @getValue()
    @namePreviewEl.text(value.name || @opts.unnamed_layer)
    @colorPreviewEl.css
      'background-color': value.fill_color
      'border-color': value.stroke_color

  onChange: ->
    @update()
    App.mediator.publish 'layerItem:changed' if @getValue()

  dataChanged: (evt, index) ->
    @onChange() if index is @index

  toggleData: (evt)->
    evt.preventDefault()
    if @data.status is 'hidden' then @data.show() else @data.hide()

  bindEvents: ->
    @el.find('.list-item-remove-btn').click @onRemove.bind(this)
    @el.find('.list-item-metadata-btn').click @toggleData.bind(this)

    App.mediator.subscribe 'layerData:changed', @dataChanged.bind(this)


#TODO: allow to reorder
App.components.editLayers = ->
  itemDefaultValue:
    visible: true
    fill_color: () -> '#'+Math.floor(Math.random()*16777215).toString(16)
    stroke_color: () -> '#'+Math.floor(Math.random()*16777215).toString(16)

  attributes: ->
    itemsContainer: @container.find('.layers-list')
    addButton     : @container.find('.add-new-btn')
    layersInput   : @container.find('.layers-value')
    items         : []
    counter       : 0

  initialize: ->
    layers = @attr.layersInput.val()
    if layers.length > 0 && layers isnt '[]'
      @loadData()
    else
      @addItem()  # show an empty new entry
    @listen()

  loadData: ->
    entries = JSON.parse @attr.layersInput.val()
    _.each entries, (entry) =>
      item = @addItem()
      item.setValue(entry)

  addItem: ->
    item = LayerItem().init _.extend({}, @attr.data, {index: @attr.counter++})
    item.setValue @itemDefaultValue
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
      vals.push item.getValue() if item && item.validateValue()
    @attr.layersInput.val JSON.stringify(vals)
