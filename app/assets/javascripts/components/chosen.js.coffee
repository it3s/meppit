#= require chosen-jquery

App.components.chosen = (container) ->
  {
    container: container

    colors: {light: "#8d8d8d", dark: '#333'}

    init: ->
      @startPlugin()

    valueLabel: ->
      @container.siblings('.chosen-container').find('.chosen-single span')

    setTextColor: (type)->
      @valueLabel().css('color', @colors[type])

    onChange: (evt, data)->
      colorType = if data.selected?.length > 0 then 'dark' else 'light'
      @setTextColor colorType

    startPlugin: ->
      @container.chosen().change @onChange.bind(this)
  }
