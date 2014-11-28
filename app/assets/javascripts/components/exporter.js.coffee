App.components.exporter = ->
  attributes: ->
    _form = $("#bulk-download-form")
    {
      is_bulk:        _form.length > 0
      form:           _form
      objects_ids:   _form.find('#objects_ids')
      option:         @container.find('.option')
    }

  initialize: ->
    @on @attr.option, 'click', @onClick

  onClick: (evt) ->
    if @attr.is_bulk
      ids = _.map $('.list-item input[type=checkbox]:checked'), (el) -> el.value
      @attr.objects_ids.val ids.join(',')
      @attr.form.attr('action', $(evt.target).attr('href')).submit()
      @closeModal()
      return false
    @closeModal()

  closeModal: ->
    App.mediator.publish 'modal:close'
