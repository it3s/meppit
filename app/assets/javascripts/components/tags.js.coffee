#= require jquery.tagsinput

App.components.tags = (container) ->
    container: container

    init: ->
      console.log @container.data('tags')
