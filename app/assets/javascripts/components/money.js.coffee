#= require jquery.maskMoney

App.components.money = (container) ->
  container: container

  init: ->
    @container.maskMoney thousands: ''
