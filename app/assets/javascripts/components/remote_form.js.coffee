App.components.remote_form = (container) ->
  {
    container: container,

    init: ->
      @bind_events()

    on_error: (_this, el, response) ->
      err_msg = JSON.parse(response.responseText)?.error || 'Error'
      _this.container.find('.errors').remove()
      _this.container.prepend("<p class='errors'>#{ err_msg }</p>")

    on_success: (_this, el, response) ->
      window.location.href = response.redirect

    bind_events: ->
      @container.on 'ajax:error', (el, response) =>
        @on_error this, el, response

      @container.on 'ajax:success', (el, response) =>
        @on_success this, el, response
  }
