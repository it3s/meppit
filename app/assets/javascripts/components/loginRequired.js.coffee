App.components.loginRequired = (container) ->
  {
    container: @container || container

    loginModalId: 'modal:sign-in-modal'

    initialize: -> @init()

    init: ->
      @bindEvent() unless $.cookie('logged_in')

    bindEvent: ->
      @container.on 'click', (evt) =>
        evt.preventDefault()
        App.components._instances[@loginModalId].open()

  }
