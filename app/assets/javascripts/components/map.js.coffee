#= require meppit-map

App.components.map = ->
  geometrySelectorTemplate: JST['templates/mapGeometrySelector']
  locationSelectorTemplate: JST['templates/mapLocationSelector']

  initialize: ->
    @drawAssistenceSteps = [
      @drawAssistenceGeometrySelection,
      @drawAssistenceLocationSelection
    ]
    @startMap()
    @bindEvents()
    if @attr.editor and not @attr.hasLocation
      @startDrawAssistence()

  startDrawAssistence: ->
    @mapEl.hide()
    @drawAssistenceRemainingSteps = @drawAssistenceSteps.slice()
    @drawAssistenceGoToNextStep()

  drawAssistenceGoToNextStep: ->
    step = @drawAssistenceSteps.shift()
    if step
      step.bind(this)()
    else
      @onFinishDrawAssistence()

  drawAssistenceStepFinished:->
    @drawAssistenceGoToNextStep()

  onFinishDrawAssistence: ->
    @mapEl.show()
    @map.refresh()
    setTimeout =>
      @map.fit @drawAssistenceLocation
      @draw @drawAssistenceGeometryType
    , 100

  drawAssistenceGeometrySelection: ->
    @geometrySelectorEl = $ @geometrySelectorTemplate()
    @container.prepend @geometrySelectorEl
    @bindGeometrySelectorEvents()

  bindGeometrySelectorEvents: ->
    @geometrySelectorEl.find('.option').click @onGeometrySelected.bind(this)

  onGeometrySelected: (evt) ->
    evt.preventDefault()
    @drawAssistenceGeometryType =  $(evt.target).data 'geometry-type'
    @geometrySelectorEl.hide()
    @drawAssistenceStepFinished()

  drawAssistenceLocationSelection: ->
    @locationSelectorEl = $ @locationSelectorTemplate()
    @locationSelectorQuestionEl =
      @locationSelectorEl.find("#location-selector-question").show()
    @locationSelectorInstructionsEl =
      @locationSelectorEl.find("#location-selector-instructions").hide()
    @container.prepend @locationSelectorEl
    @bindLocationSelectorEvents()

  bindLocationSelectorEvents: ->
    @locationSelectorEl.find('.option').click @onLocationSelected.bind(this)

  onLocationSelected: (evt) ->
    evt.preventDefault()
    @drawAssistenceIsNear = $(evt.target).data 'is-near'
    onSuccess = (e) =>
      console.log e
      @drawAssistenceLocation = e.location
      @locationSelectorEl.hide()
      @drawAssistenceStepFinished()
    if @drawAssistenceIsNear
      @map.locate onSuccess
      @locationSelectorQuestionEl.hide()
      @locationSelectorInstructionsEl.show()
    else
      # TODO: add search option
      @locationSelectorEl.hide()
      @drawAssistenceStepFinished()

  startMap: ->
    L.Icon.Default.imagePath = '/assets'
    window.map = this
    @mapEl = $('<div>').addClass('map-container')
    @container.append @mapEl
    @map = new Meppit.Map
      element: @mapEl[0],
      enableGeoJsonTile: false
      featureURL: '#{baseURL}geo_data/#{id}/export.geojson'
    feature = @attr.geojson or @attr.geoDataIds
    if feature
      @show feature
      @edit feature if @attr.editor

  edit: (feature) ->
    @map.edit feature, @updateInput.bind(this)

  onDraw: (feature) ->
   @updateInput()
   @edit feature

  draw: (feature) ->
    @map.draw feature, @onDraw.bind(this)

  updateInput: ->
    $(@attr.inputSelector).val JSON.stringify(@map.toSimpleGeoJSON())

  show: (feature) ->
    @map.show feature, @updateInput.bind(this)

  bindEvents: ->
    App.mediator.subscribe 'remoteForm:beforeSubmit', () =>
      @map.done()

  expand: ->
    @_originalScrollTop = $(window).scrollTop()
    @_originalCss =
      position: @container.css('position')
      top: @container.css('top')
      left: @container.css('left')
      height: @container.css('height')
      width: @container.css('width')
      'z-index': @container.css('z-index')
    top = $("#header").height()
    $(window).scrollTop(0)
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
    $(window).scrollTop(@_originalScrollTop)
    @container.css @_originalCss
    @map.refresh()
    @expanded = false
