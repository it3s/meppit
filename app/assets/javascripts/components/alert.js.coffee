App.components.alert = (container) ->
  attributes: ->
    fadeTime   : 200
    closeTime  : 2000
    closeButton: @container.find('.close')
    closed     : false
    alerts     : @container.closest('.alerts')

  initialize: ->
    @bindEvents()
    setTimeout @close.bind(this), @attr.closeTime

  bindEvents: ->
    @on @attr.closeButton, 'click', @close

  close: () ->
    unless @attr.closed
      @attr.closed = true
      $.when(@container.fadeOut @attr.fadeTime).then @afterFade.bind(this)

  afterFade: ->
    @container.remove()
    @attr.alerts.remove() if @emptyAlerts()

  emptyAlerts: ->
    @attr.alerts.find('.alert').length is 0
