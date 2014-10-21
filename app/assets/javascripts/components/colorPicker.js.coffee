#= require colpick
#
App.components.colorPicker = ->
  attributes: ->
    defaultColor: @attr.color || @container.val?() || '#0000ff'

  initialize: ->
    @findElements()
    @bindEvents()
    @initializePicker()
    @setValue @attr.defaultColor

  initializePicker: ->
    @pickerEl.addClass 'color-picker'
    @previewEl = $ '<div class="color-picker-preview"></div>'
    @previewEl.css 'background-color', @getValue()
    @fieldEl?.val @getValue()
    @pickerEl.append @previewEl
    @fieldEl?.hide()
    @pickerEl.colpick
      layout: 'hex'
      color: @attr.defaultColor
      submit: false
      onChange: @onPickerChange.bind(this)

  findElements: ->
    if @container.is 'input'
      @fieldEl = @container
      @pickerEl = $('<div>')
      @fieldEl.before @pickerEl
    else
      @pickerEl = @container

  bindEvents: ->
    @fieldEl?.change @onFieldChange.bind(this)

  setValue: (value) ->
    @color = value
    @update()

  getValue: -> @color

  onPickerChange: (hsb, hex, rgb, el, bySetColor) ->
    @onChange '#' + hex

  onFieldChange: ->
    @onChange @fieldEl.val()

  onChange: (color) ->
    @setValue color
    App.mediator.publish 'colorpicker:changed', color

  update: ->
    @previewEl.css 'background-color', @getValue()
    @container.data 'colorPicker-color', @getValue()
    @fieldEl?.val @getValue()
