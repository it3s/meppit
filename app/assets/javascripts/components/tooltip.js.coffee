#= require jquery.qtip

App.components.tooltip = (container) ->
  container: container

  init: () ->
    data = @container.data('tooltip')
    console.log(data.content)
