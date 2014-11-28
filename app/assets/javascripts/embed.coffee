#= require underscore
#= require jquery
#= require jquery_ujs
#= require jquery.cookie

#= require base

#= require ./templates/layerData
#= require ./templates/layerItem
#= require ./components/layers
#= require ./components/map

onReady = ->
  App.mediator.publish('components:start')

$(document).ready onReady


# add private properties to be tested
window.__testing__?.embed =
  onReady: onReady
