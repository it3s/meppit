#= require meppit-map

App.components.map = (container) ->
  {
    container: container

    init: ->
      L.Icon.Default.imagePath = '/assets'  # FIXME: should not be done here.
      @geojson = @container.data('geojson')
      @startMap()

    startMap: ->
      el = @container[0]
      @map = new Meppit.Map
        element: el,
        enableGeoJsonTile: false

      @map.show(@geojson)

  }
