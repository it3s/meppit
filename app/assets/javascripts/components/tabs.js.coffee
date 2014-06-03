#= require jquery.ui.tabs

App.components.tabs = (container) ->
  {
    container: container,

    init: ->
      @container.tabs()

  }
