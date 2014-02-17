#= require jquery.flexslider

class App.components.Flexslider
  constructor: (@container) ->
    @start_plugin()

  start_plugin: ->
    @container.flexslider
      animation: 'slide'

  pause: ->
    @container.flexslider 'pause'
