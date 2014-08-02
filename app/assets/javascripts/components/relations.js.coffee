App.components.relations = (container) ->
  {
    container: container
    addButton: container.find('.add-new-relation')
    template : container.find('#relation-form-template')

    init: ->
      @listen()

    onAdd: (evt) ->
      evt.preventDefault()

      item = $ @template.html()
      @container.append item
      App.mediator.publish 'components:start', item

    listen: ->
      @addButton.click @onAdd.bind(this)

  }
