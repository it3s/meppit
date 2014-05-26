#= require jquery.tagsinput

App.components.tags = (container) ->
    container: container

    init: ->
      tags = @container.data('tags')
      @input = @container.find("#tags-input")
      @setValue(tags) if tags.length > 0
      @startPlugin()

    setValue: (tags)->
      @input.val tags.join(',')

    startPlugin: ->
      @input.tagsInput()
