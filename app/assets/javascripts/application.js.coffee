#= require underscore
#= require jquery
#= require jquery_ujs
#= require jquery.remotipart

#= require base

#= require components/modal
#= require components/remote_form
#= require components/alert
#= require components/editor
#= require components/overlay
#= require components/map
#= require components/tooltip

onReady = ->
  App.mediator.publish('components:start')

$(document).ready onReady


# add private properties to be tested
window.__testing__?.application =
  onReady: onReady
