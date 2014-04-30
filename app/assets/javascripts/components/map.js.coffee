#= require meppit-map

App.components.map = (container) ->
  {
    container: container

    init: ->
      @geojson = @container.data('geojson')
      @startMap()

    startMap: ->
      el = @container[0]
      @map = new Meppit.Map
        element: el,
        enableGeoJsonTile: false

      @map.load(@geoJson)

  }
