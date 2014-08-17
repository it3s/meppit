App.components.loginRequired = ->
  attributes: ->
    loginModal: 'modal:sign-in-modal'

  initialize: ->
    @on 'click', @openLoginModal unless @loggedIn()

  loggedIn: ->
    !!$.cookie('logged_in')

  openLoginModal: (evt) ->
    evt.preventDefault()
    App.mediator.publish 'modal:open', {identifier: @attr.loginModal}
    false
