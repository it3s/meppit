#= require jquery.qtip

App.components.tooltip = (container) ->
  container: container

  init: () ->
    @data = @container.data('tooltip')
    @startPlugin()

  startPlugin: ->
    content = @data.content
    container = @container
    @container.qtip
      show: 'mousedown'
      content: content
      style:
        classes: 'tooltip qtip-light qtip-shadow qtip-rounded'
      hide:
        event: 'unfocus'
      position:
        my: 'top center'
        adjust:
          x: -50, y: 5
      events:
        show: (event, api) ->
          console.log this
          container.addClass 'active'
        hide: (event, api) ->
          container.removeClass 'active'
