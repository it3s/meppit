#= require underscore
#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require jquery.ui.autocomplete
#= require jquery.ui.datepicker
#= require jquery.ui.datepicker-pt-BR
#= require jquery.infinitescroll
#= require jquery.cookie
#= require jquery.sticky-kit.min

#= require base

#= require_tree ./templates
#= require_tree ./components

onReady = ->
  App.faye = new Faye.Client(fayeUrl)
  App.mediator.publish('components:start')
  $('.central-pane, .side-pane').stick_in_parent()

$(document).ready onReady


# add private properties to be tested
window.__testing__?.application =
  onReady: onReady
