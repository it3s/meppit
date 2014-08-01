App.components.relations = (container) ->
  {
    container: container
    addButton: container.find('.add-new-relation')
    template : container.find('#relation-form-template')

    init: ->
      @listen()

    onAdd: (evt) ->
      evt.preventDefault()
      @container.append $(@template.html())
      false

    listen: ->
      @addButton.click @onAdd.bind(this)

  }
