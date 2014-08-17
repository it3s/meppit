App.components.remoteForm = ->
  initialize: ->
    @on 'ajax:complete', @onAjaxComplete.bind(this)

  onAjaxComplete: (el, response) ->
    callback = if parseInt(response.status, 10) is 200 then @onSuccess else @onError
    callback.bind(this)(el, JSON.parse(response.responseText))

  onSuccess: (el, response) ->
    if response.redirect
      window.location.href = response.redirect
    else
      App.mediator.publish 'remoteForm:success', {identifier: @identifier, response: response}

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
    App.mediator.publish 'remoteForm:error', {identifier: @identifier, response: response}

  cleanErrors: ->
    @container.find('.error').remove()
    @container.find('.field_with_errors').removeClass('field_with_errors')


