App.components.remoteForm = (container) ->
  {
    container: container,

    init: ->
      @bindEvents()

    cleanErrors: ->
      @container.find('.error').remove()
      @container.find('.field_with_errors').removeClass('field_with_errors')

    onError: (el, response) ->
      err = response.errors || 'Error'
      @cleanErrors()
      if _.isObject err
        _.each err, (value, key) =>
          field = @container.find("[name*='[#{key}]']").closest('.field')
          field.addClass('field_with_errors')
          field.append("<div class='error'>#{value[0]}</div>")

      else
        submitContainer = @container.find('input[type=submit]').closest('p')
        submitContainer.before("<p class='error all'>#{ err }</p>")

    onSuccess: (el, response) ->
      window.location.href = response.redirect if response.redirect

    bindEvents: ->
      @container.on 'ajax:complete', (el, response) =>
        callback = if parseInt(response.status, 10) is 200 then @onSuccess else @onError
        callback.bind(this)(el, JSON.parse(response.responseText))
  }
