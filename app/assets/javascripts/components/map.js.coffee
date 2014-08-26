#= require meppit-map

App.components.map = ->
  initialize: ->
    @startMap()
    @show() if @attr.geoDataIds

  startMap: ->
    L.Icon.Default.imagePath = '/assets'
    @map = new Meppit.Map
      element: @container[0],
      enableGeoJsonTile: false
      featureURL: '#{baseURL}geo_data/#{id}/export.geojson'

  show: ->
    @map.show @attr.geoDataIds

