#= require jquery
#= require jquery_ujs
#= require underscore

#= require base

#= require components/modal
#= require components/remote_form
#= require components/alert
#= require components/editor

onReady = ->
  App.mediator.publish('components:start')

$(document).ready onReady


# add private properties to be tested
window.__testing__?.application =
  onReady: onReady
