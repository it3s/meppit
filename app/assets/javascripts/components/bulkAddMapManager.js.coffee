App.components.bulkAddMapManager = (container) ->
  {
    container: container

    formId: 'remoteForm:bulk-add-to-map-form'

    init: ->
      @addListeners()

    addListeners: ->
      App.utils.whenComponentStarted @formId, @listen.bind(this)

    closeModal: ->
      @form.container.find('input[name=map]').val('')
      @form.container.find('input[name=map_autocomplete]').val('')
      $.modal.close()

    onSuccess: (el, response) ->
      @closeModal()
      App.utils.flashMessage(response.flash)

    onError: (el, response) ->
      @closeModal()
      App.utils.flashMessage(response.flash)

    onOpen: ->
      ids = _.map $('.list-item input[type=checkbox]:checked'), (el) -> el.value
      $('#geo_data_ids').val ids.join(',')

    listen: ->
      _this = this
      @form = App.components._instances[@formId]

      @form.onSuccess = @onSuccess.bind(_this)
      @form.onError = @onError.bind(_this)

      $('#bulk-add-to-map').on 'click', @onOpen.bind(_this)
  }
