App.components.remoteForm = (container) ->
  {
    container: container,

    init: ->
      @bindEvents()

    cleanErrors: ->
      @container.find('.error').remove()
      @container.find('.field_with_errors').removeClass('field_with_errors')

    onError: (_this, el, response) ->
      err = response.errors || 'Error'
      _this.cleanErrors()
      if _.isObject err
        _.each err, (value, key) ->
          field = _this.container.find("[name*='[#{key}]']").closest('.field')
          field.addClass('field_with_errors')
          field.append("<div class='error'>#{value[0]}</div>")

      else
        submitContainer = _this.container.find('input[type=submit]').closest('p')
        submitContainer.before("<p class='error all'>#{ err }</p>")

    onSuccess: (_this, el, response) ->
      window.location.href = response.redirect if response.redirect

    bindEvents: ->
      @container.on 'ajax:complete', (el, response) =>
        callback = if parseInt(response.status, 10) is 200 then @onSuccess else @onError
        callback this, el, JSON.parse(response.responseText)
  }
