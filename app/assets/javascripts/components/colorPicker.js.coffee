#= require colpick
#
App.components.colorPicker = ->
  attributes: ->
    defaultColor: @attr.color || '#0000ff'

  initialize: ->
    @container.colpick
      layout: 'hex'
      color: @attr.defaultColor
      submit: false
      onChange: @onChange.bind(this)

  onChange: (hsb, hex, rgb, el, bySetColor) ->
    @container.css 'background-color', '#'+hex
    @container.data 'colorPicker-color', '#'+hex
    App.mediator.publish 'colorpicker:changed', '#'+hex
