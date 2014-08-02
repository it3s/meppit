#= require chosen-jquery

App.components.chosen = (container) ->
  {
    container: container

    init: ->
      @startPlugin()

    startPlugin: ->
      @container.chosen()
  }
