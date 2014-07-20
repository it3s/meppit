App.components.addToMapManager = (container) ->
  {
    container: container

    formId: 'remoteForm:add-to-map-form'

    init: ->
      @identifier = @container.data('identifier')
      @addListeners()

    addListeners: ->
      if App.components._instances[@formId]
        @listen()
      else
        App.mediator.subscribe 'component:started', (evt, componentId) =>
          @listen() if componentId is @formId

    closeModal: ->
      @form.container.find('input[name=map]').val('')
      @form.container.find('input[name=map_autocomplete]').val('')
      $.modal.close()

    onSuccess: (el, response) ->
      @closeModal()
      App.mediator.publish("mapping:changed", {id: @identifier, count: response.count})
      App.flashMessage(response.flash)

    onError: (el, response) ->
      @closeModal()
      App.flashMessage(response.flash)

    listen: ->
      _this = this
      @form = App.components._instances[@formId]

      @form.onSuccess = @onSuccess.bind(_this)
      @form.onError = @onError.bind(_this)

  }
