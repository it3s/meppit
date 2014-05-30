#= require jquery.tagsinput

App.components.tags = (container) ->
    container: container

    init: ->
      tags = @container.data('tags')
      @loadValues(tags)
      @startPlugin()

    loadValues: (tags) ->
      @container.val tags.join(',')

    defaulOptions:
      defaultText     : I18n.tags.placeholder
      width           : '100%'
      placeholderColor: '#999'

    getOptions: (autocomplete)->
      extraOptions = if autocomplete then {autocomplete_url: autocomplete} else {}
      _.extend {}, @defaultOptions, extraOptions

    startPlugin: ->
      opts = @getOptions @container.data('autocomplete')
      @container.tagsInput opts
