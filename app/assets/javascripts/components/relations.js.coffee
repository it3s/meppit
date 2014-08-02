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
      @bindItemEvents item

    onClickRemove: (evt) ->
      evt.preventDefault()
      item = $(evt.target).closest('.relation-item')
      item.fadeOut 100, -> item.remove()

    listen: ->
      @addButton.click @onAdd.bind(this)

    bindItemEvents: (item) ->
      App.mediator.publish 'components:start', item

      item.find('.relation-remove').click @onClickRemove.bind(this)

  }
