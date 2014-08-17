App.components.addMapping = (container) ->
  # attr => formId, mapping, objectIdentifier
  attributes: ->
    _form = $("##{@attr.formId}")
    {
      formIdentifier: "remoteForm:#{@attr.formId}"
      input:          _form.find("input[name=#{@attr.mapping}]")
      autocomplete:   _form.find("input[name=#{@attr.mapping}_autocomplete]")
    }

  initialize: ->
    App.mediator.subscribe 'remoteForm:success', @onSuccess.bind(this)
    App.mediator.subscribe 'remoteForm:error', @onError.bind(this)

  onSuccess: (evt, data) ->
    if data.identifier is @attr.formIdentifier
      @closeModal()
      App.mediator.publish("mapping:changed", {id: @attr.objectIdentifier, count: data.response.count})
      App.utils.flashMessage(data.response.flash)

  onError: (evt, data) ->
    if data.identifier is @attr.formIdentifier
      @closeModal()
      App.utils.flashMessage(data.response.flash)

  closeModal: ->
    @attr.input.val('')
    @attr.autocomplete.val('')
    App.mediator.publish('modal:close')
