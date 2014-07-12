App.components.loginRequired = (container) ->
  {
    container: container

    loginModalId: 'modal:sign-in-modal'

    init: ->
      @bindIfNotlogged()

    bindIfNotlogged: ->
      $.getJSON '/sessions/logged_in/'
      .then (data) =>
        @container.data('loggedIn', data.logged_in)
        @bindEvent() if data.logged_in is false

    bindEvent: ->
      @container.on 'click', (evt) =>
        evt.preventDefault()
        App.components._instances[@loginModalId].open()


  }
