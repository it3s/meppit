#= require jquery
#= require jquery_ujs
#= require underscore

#= require base

#= require components/modal
#= require components/remote_form

$ ->
  App.mediator.publish('components:start')
