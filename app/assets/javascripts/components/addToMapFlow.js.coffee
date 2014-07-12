App.components.addToMapFlow = (container) ->
  {
    container: container

    formId: 'remoteForm:add-to-map-form'

    init: ->
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
      App.flashMessage(response.flash)

    listen: ->
      _this = this
      @form = App.components._instances[@formId]
      cancelButton = @container.find(".cancel-btn")

      cancelButton.on 'click', @closeModal.bind(_this)
      @form.onSuccess = @onSuccess.bind(_this)

  }
