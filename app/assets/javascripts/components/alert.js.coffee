App.components.alert = (container) ->
  {
    container: container
    fadeTime: 200

    init: ->
      @closeButton = @container.find('.close')
      @bindEvents()

    close: (_this) ->
      alertsContainer = _this.container.closest('.alerts')
      _this.container.fadeOut _this.fadeTime, ->
        _this.container.remove()
        alertsContainer.remove() if alertsContainer.find('.alert').length is 0

    bindEvents: ->
      @closeButton.on 'click', => @close(this)
  }
