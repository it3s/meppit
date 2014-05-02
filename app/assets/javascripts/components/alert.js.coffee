App.components.alert = (container) ->
  {
    container: container
    fadeTime: 200

    init: ->
      @closeButton = @container.find('.close')
      @bindEvents()

    close: () ->
      alertsContainer = @container.closest('.alerts')
      $.when(@container.fadeOut @fadeTime).then =>
        @container.remove()
        alertsContainer.remove() if alertsContainer.find('.alert').length is 0

    bindEvents: ->
      @closeButton.on 'click', @close.bind(this)
  }
