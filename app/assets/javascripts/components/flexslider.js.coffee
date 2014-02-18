#= require jquery.flexslider

App.components.flexslider = (container) ->
  {
    container: container,

    init: ->
      @start()

    start: ->
      @container.flexslider
        animation: 'slide'
      console.log('components: started flexslider');


    pause: ->
       @container.flexslider 'pause'
  }
