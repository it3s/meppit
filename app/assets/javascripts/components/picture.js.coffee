App.components.picture = ->
  attributes: ->
    saveButton:   @container.find('.save-button')
    deleteButton: @container.find('.delete-button')

  initialize: ->
    @on @attr.saveButton,   'click', @onSave
    @on @attr.deleteButton, 'click', @onDelete

  onSave: (evt) ->
    evt.preventDefault()
    @xhrRequest('update')

  onDelete: (evt) ->
    evt.preventDefault()
    @xhrRequest('delete')

  xhrRequest: (type) ->
    method = if type is 'delete' then 'DELETE'  else 'PUT'
    action = if type is 'delete' then 'deleted' else 'updated'
    $.ajax
      type:     method
      url:      @attr.url
      dataType: "json"
      data:     {picture: {description: @container.find('#description').val()}}
      success:  (data) =>
        App.mediator.publish "picture:#{action}", data
        App.utils.flashMessage(data.flash)
        App.mediator.publish 'modal:close'
