#= require meppit-map

App.components.map = ->
  initialize: ->
    @startMap()
    @show() if @attr.geojson

  startMap: ->
    @map = new Meppit.Map
      element:           @container[0],
      enableGeoJsonTile: false

  show: ->
    @map.show @attr.geojson

