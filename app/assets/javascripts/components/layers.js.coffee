App.components.layers = ->
  initialize: ->
    @findElements()
    @initElements()
    @bindEvents()

  findElements: ->
    @layerEl = @container.find '.layer'

  initElements: ->
    @layerEl.each (idx, el) ->
      el = $ el
      layer = el.data 'layer'
      el.find('.layer-color-preview').css
        backgroundColor: layer.fill_color
        borderColor: layer.stroke_color

  bindEvents: ->
    @layerEl.click @onLayerClick.bind(this)

  onLayerClick: (evt) ->
    el = $ evt.currentTarget
    @_toggleLayer el

  _toggleLayer: (el) ->
    layer = el.data 'layer'
    el.toggleClass 'hidden', layer.visible
    layer.visible = not layer.visible
    el.data 'layer', layer
    action = if layer.visible then 'shown' else 'hidden'
    App.mediator.publish "layer:#{action}", {id: layer.id}




