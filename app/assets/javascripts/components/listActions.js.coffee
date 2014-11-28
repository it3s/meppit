App.components.listActions = ->
  attributes: ->
    bulkButtons: @container.find('.bulkActions button')

  initialize: ->
    @count = 0
    @updateBulkButtons()
    @bindEvents()

  bindEvents: ->
    App.mediator.subscribe "listItem:selected", (evt, data) =>
      @count++
      @updateBulkButtons()

    App.mediator.subscribe "listItem:unselected", (evt, data) =>
      @count--
      @updateBulkButtons()

    App.mediator.subscribe "list:unselectedAll", (evt, data) =>
      @count = 0
      @updateBulkButtons()

    App.mediator.subscribe "list:selectedAll", (evt, data) =>
      @count = data.count
      @updateBulkButtons()

  updateBulkButtons: ->
    @attr.bulkButtons.prop "disabled", (@count is 0)
