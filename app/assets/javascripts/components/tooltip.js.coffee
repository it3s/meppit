#= require jquery.qtip

App.components.tooltip = ->
  initialize: ->
    @startPlugin()

  onShow: ->
    @container.addClass 'active'
    App.mediator.publish 'components:start', $('.qtip-content')

  onHide: ->
    @container.removeClass 'active'

  startPlugin: (content) ->
    console.log 'starting tooltip for ', @identifier
    @container.qtip
      show: 'mousedown'
      content: $(@attr.template).html()
      style:
        classes: 'tooltip qtip-light qtip-shadow qtip-rounded'
      hide:
        event: 'unfocus'
      position:
        my: 'top center'
        adjust: { x: -50, y: 5 }
      events:
        show: @onShow.bind(this)
        hide: @onHide.bind(this)

