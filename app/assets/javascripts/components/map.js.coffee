#= require meppit-map

App.components.map = (container) ->
  {
    container: container

    init: ->
      @geojson = @container.data('geojson')
      @startMap()
      @show() if @geojson

    startMap: ->
      el = @container[0]
      @map = new Meppit.Map
        element: el,
        enableGeoJsonTile: false

    show: ->
      @map.show @geojson

  }
