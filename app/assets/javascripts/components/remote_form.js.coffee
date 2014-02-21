App.components.remote_form = (container) ->
  {
    container: container,

    init: ->
      @bind_events()

    clean_errors: ->
      @container.find('.error').remove()
      @container.find('.field_with_errors').removeClass('field_with_errors')

    on_error: (_this, el, response) ->
      err = JSON.parse(response.responseText)?.errors || 'Error'
      _this.clean_errors()
      try
        err = JSON.parse err
        _.each err, (value, key) ->
          field = _this.container.find("[name*='[#{key}]']").closest('.field')
          field.addClass('field_with_errors')
          field.append("<div class='error'>#{value}</div>")

      catch
        _this.container.find('.error.all').remove()
        _this.container.prepend("<p class='error all'>#{ err }</p>")

    on_success: (_this, el, response) ->
      window.location.href = response.redirect

    bind_events: ->
      @container.on 'ajax:error', (el, response) =>
        @on_error this, el, response

      @container.on 'ajax:success', (el, response) =>
        @on_success this, el, response
  }
