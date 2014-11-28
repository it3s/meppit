App.components.selectAll = ->
  attributes: ->
    checkbox:     @container.find('input[type=checkbox]')

  initialize: ->
    @on 'click', @toggle

    App.mediator.subscribe "listItem:unselected", (evt, data) =>
      @uncheck() if @checked()

  toggle: ->
    if @checked() then @uncheck() else @check()
    App.mediator.publish "list:#{ if @checked() then "selectAll" else "unselectAll" }"

  checked: ->
    @attr.checkbox.is(':checked')

  check: ->
    @setCheck(true)

  uncheck: ->
    @setCheck(false)

  setCheck: (val) ->
    @attr.checkbox.prop('checked', val)
