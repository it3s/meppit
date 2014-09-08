App.components.selectAll = ->
  attributes: ->
    checkbox:     @container.find('input[type=checkbox]')
    listItems:    $('.list-item input[type=checkbox]')
    itemsChecked: '.list-item input[type=checkbox]:checked'
    count:        $('.selected-count')

  initialize: ->
    @on 'click', @toggle
    @on @attr.listItems, 'change', @updateSelectCount

  toggle: ->
    if @checked() then @uncheck() else @check()
    @updateSelectCount()

  checked: ->
    @attr.checkbox.is(':checked')

  check: ->
    @setCheck(true)

  uncheck: ->
    @setCheck(false)

  setCheck: (val) ->
    @attr.checkbox.prop('checked', val)
    @attr.listItems.prop('checked', val)

  updateSelectCount: (evt, el) ->
    count = $(@attr.itemsChecked).length
    @attr.count.text if count > 0 then I18n.pluralize(I18n.lists.selected, count) else ""


