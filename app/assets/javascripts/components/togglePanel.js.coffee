App.components.togglePanel = ->
  attributes: ->
    panel : $("#{@container.attr('href')}")
    status: 'hidden'

  initialize: ->
    @on 'click', @toggle

  show: ->
    @attr.panel.slideDown('fast')
    @attr.status = 'visible'

  hide: ->
    @attr.panel.slideUp('fast')
    @attr.status = 'hidden'

  toggle: (evt) ->
    evt.preventDefault()
    if @attr.status is 'visible' then @hide() else @show()
