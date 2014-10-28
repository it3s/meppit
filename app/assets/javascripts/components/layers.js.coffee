App.components.layers = ->
  initialize: ->
    @_layersEls = {}
    @findElements()
    @initElements()
    @bindEvents()

  findElements: ->
    @layerEl = @container.find '.layer'

  initElements: ->
    @layerEl.each (idx, el) =>
      el = $ el
      layer = el.data 'layer'
      @_layersEls[layer.id] = el
      el.css cursor: 'pointer'
      el.find('.layer-color-preview').css
        backgroundColor: layer.fill_color
        borderColor: layer.stroke_color

  bindEvents: ->
    @layerEl.click @onLayerClick.bind(this)
    App.mediator.subscribe "layer:show", @onShow.bind(this)
    App.mediator.subscribe "layer:hide", @onHide.bind(this)

  onLayerClick: (evt) ->
    el = $ evt.currentTarget
    @_toggleLayer el

  _toggleLayer: (el) ->
    layer = el.data 'layer'
    action = if layer.visible then 'hide' else 'show'
    App.mediator.publish "layer:#{action}", {id: layer.id}

  _getLayerEl: (id) ->
    @_layersEls[id]

  onShow: (evt, data) ->
    el = @_getLayerEl data.id
    layer = el.data 'layer'
    el.removeClass 'hidden'
    layer.visible = true
    el.data 'layer', layer

  onHide: (evt, data) ->
    el = @_getLayerEl data.id
    layer = el.data 'layer'
    el.addClass 'hidden'
    layer.visible = false
    el.data 'layer', layer
