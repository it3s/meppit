App.components.selectAll = (container) ->
  {
    container: container

    init: ->
      @checkbox = @container.find('input[type=checkbox]')
      @listItems = $('.list-item input[type=checkbox]')
      @bindEvents()

    checked: ->
      @checkbox.is(':checked')

    setCheck: (val) ->
      @checkbox.prop('checked', val)
      @listItems.prop('checked', val)

    check:   -> @setCheck(true)
    uncheck: -> @setCheck(false)

    toggle: ->
      if @checked() then @uncheck() else @check()

    bindEvents: ->
      @container.click @toggle.bind(this)
  }
