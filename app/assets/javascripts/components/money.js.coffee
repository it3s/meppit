#= require jquery.maskMoney

App.components.money = ->
  initialize: -> @container.maskMoney thousands: ''
