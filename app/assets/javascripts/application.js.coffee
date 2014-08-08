#= require underscore
#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require jquery.ui.autocomplete
#= require jquery.ui.datepicker
#= require jquery.ui.datepicker-pt-BR
#= require jquery.infinitescroll
#= require jquery.cookie

#= require base

#= require_tree ./templates
#= require_tree ./components

onReady = ->
  App.mediator.publish('components:start')

$(document).ready onReady


# add private properties to be tested
window.__testing__?.application =
  onReady: onReady
