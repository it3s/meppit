App.components.selectAll = ->
  attributes: ->
    checkbox: @container.find('input[type=checkbox]')
    listItems: $('.list-item input[type=checkbox]')

  initialize: ->
    @on 'click', @toggle

  toggle: ->
    if @checked() then @uncheck() else @check()

  checked: ->
    @attr.checkbox.is(':checked')

  check: ->
    @setCheck(true)

  uncheck: ->
    @setCheck(false)

  setCheck: (val) ->
    @attr.checkbox.prop('checked', val)
    @attr.listItems.prop('checked', val)


