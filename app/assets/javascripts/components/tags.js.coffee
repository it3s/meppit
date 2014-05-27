#= require jquery.tagsinput

App.components.tags = (container) ->
    container: container

    init: ->
      tags = @container.data('tags')
      @loadValues(tags)
      @startPlugin()

    loadValues: (tags) ->
      @container.val tags.join(',')

    startPlugin: ->
      @container.tagsInput
        # 'autocomplete_url':'%(url)s',
        defaultText     : I18n.tags.placeholder
        width           : '100%'
        placeholderColor: '#999'
