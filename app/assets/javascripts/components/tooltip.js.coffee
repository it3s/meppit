#= require jquery.qtip

App.components.tooltip = (container) ->
  container: container

  init: () ->
    @data = @container.data('tooltip')
    @startPlugin()

  startPlugin: ->
    content = @data.content
    @container.qtip
      show: 'mousedown'
      content: content
      style:
        classes: 'tooltip qtip-light qtip-shadow qtip-rounded'
        tip: "top center"
      hide:
        event: 'unfocus'
      position:
        my: 'top center'
