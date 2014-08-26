#= require meppit-map

App.components.map = ->
  geometrySelectorTemplate: JST['templates/mapGeometrySelector']

  initialize: ->
    if @attr.editor and not @attr.hasLocation
      @startGeometrySelector()
    else
      @startMap()
    @bindEvents()

  startGeometrySelector: (opts) ->
    @geometrySelectorEl = $ @geometrySelectorTemplate(opts)
    @container.append @geometrySelectorEl
    @bindGeometrySelectorEvents()

  startMap: ->
    L.Icon.Default.imagePath = '/assets'
    window.map = this
    @map = new Meppit.Map
      element: @container[0],
      enableGeoJsonTile: false
      featureURL: '#{baseURL}geo_data/#{id}/export.geojson'
    feature = @attr.geojson or @attr.geoDataIds
    if feature
      @show feature
      @edit feature if @attr.editor

  onSelectGeometry: (evt) ->
    evt.preventDefault()
    geometryType =  $(evt.target).data 'geometry-type'
    @geometrySelectorEl.hide()
    @startMap()
    @draw geometryType

  bindGeometrySelectorEvents: ->
    @geometrySelectorEl.find('.option').click @onSelectGeometry.bind(this)

  edit: (feature) ->
    @map.edit feature, @updateInput.bind(this)

  draw: (feature) ->
    @map.draw feature, @updateInput.bind(this)

  updateInput: ->
    $(@attr.inputSelector).val JSON.stringify(@map.toSimpleGeoJSON())

  show: (feature) ->
    @map.show feature, @updateInput.bind(this)

  bindEvents: ->
    App.mediator.subscribe 'remoteForm:beforeSubmit', () =>
      @map.done()

  expand: ->
    @_originalCss =
      position: @container.css('position')
      top: @container.css('top')
      left: @container.css('left')
      height: @container.css('height')
      width: @container.css('width')
      'z-index': @container.css('z-index')
    top = $("#header").height()
    @container.css
      position: 'absolute'
      top: top
      left: 0
      height: $(window).height() - top
      width: $(window).width()
      'z-index': 100
    @map.refresh()
    @expanded = true

  collapse: ->
    return if not @expanded
    @container.css @_originalCss
    @map.refresh()
    @expanded = false
