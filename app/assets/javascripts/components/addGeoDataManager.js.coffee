App.components.addGeoDataManager = (container) ->
  {
    container: container

    formId: 'remoteForm:add-data-form'

    init: ->
      @identifier = @container.data('identifier')
      @addListeners()

    addListeners: ->
      App.utils.whenComponentStarted @formId, @listen.bind(this)

    closeModal: ->
      @form.container.find('input[name=geo_data]').val('')
      @form.container.find('input[name=geo_data_autocomplete]').val('')
      $.modal.close()

    onSuccess: (el, response) ->
      @closeModal()
      App.mediator.publish("mapping:changed", {id: @identifier, count: response.count})
      App.utils.flashMessage(response.flash)

    onError: (el, response) ->
      @closeModal()
      App.utils.flashMessage(response.flash)

    listen: ->
      _this = this
      @form = App.components._instances[@formId]

      @form.onSuccess = @onSuccess.bind(_this)
      @form.onError = @onError.bind(_this)
  }
