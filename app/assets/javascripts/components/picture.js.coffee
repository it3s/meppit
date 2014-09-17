App.components.picture = ->
  attributes: ->
    saveButton:   @container.find('.save-button')
    deleteButton: @container.find('.delete-button')

  initialize: ->
    @on @attr.saveButton,   'click', @onSave
    @on @attr.deleteButton, 'click', @onDelete

  onSave: (evt) ->
    evt.preventDefault()
    console.log 'onSave'

  onDelete: (evt) ->
    evt.preventDefault()
    console.log 'onDelete'
