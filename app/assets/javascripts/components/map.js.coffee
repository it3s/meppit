#= require meppit-map

App.components.map = (container) ->
  {
    container: container

    init: ->
      @geojson = @container.data('geojson')
      console.log @geojson
      @startMap()

    startMap: ->
      el = @container[0]
      console.log el
      @map = new Meppit.Map
        element: el,
        enableGeoJsonTile: false

      @map.load(@geoJson)

  }
