App.components.addMappingBulk = ->
  attributes: ->
    _form = $("#bulk-add-to-map-form")
    {
      formIdentifier: "remoteForm:bulk-add-to-map-form"
      input:          _form.find("input[name=map]")
      autocomplete:   _form.find("input[name=map_autocomplete]")
      button:         $('#bulk-add-to-map')
      geo_data_ids:   $('#geo_data_ids')
    }

  initialize: ->
    App.mediator.subscribe 'remoteForm:success', @onResponse.bind(this)
    App.mediator.subscribe 'remoteForm:error', @onResponse.bind(this)
    @on @attr.button, 'click', @onOpen

  onResponse: (evt, data) ->
    if data.identifier is @attr.formIdentifier
      @closeModal()
      App.utils.flashMessage(data.response.flash)

  onOpen: ->
    ids = _.map $('.list-item input[type=checkbox]:checked'), (el) -> el.value
    @attr.geo_data_ids.val ids.join(',')

  closeModal: ->
    @attr.input.val('')
    @attr.autocomplete.val('')
    App.mediator.publish('modal:close')



