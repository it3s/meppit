#= require jquery.flexslider

App.components.flexslider = (container) ->
  {
    container: container,

    init: ->
      @start()

    start: ->
      @container.flexslider
        animation: 'slide'

    pause: ->
       @container.flexslider 'pause'
  }
