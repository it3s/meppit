#= require jquery.tagsinput

App.components.tags = (container) ->
    container: container

    init: ->
      tags = @container.data('tags')
      @loadValues(tags)
      @startPlugin()

    loadValues: (tags) ->
      @container.val tags.join(',')

    replaceTag: (tag, new_tag) ->
      @container.removeTag(tag)
      @container.addTag(new_tag) unless @container.tagExist(new_tag)

    onAdd: (tag) ->
      lowercased = tag.toLowerCase()
      @replaceTag(tag, lowercased) unless tag is lowercased

    startPlugin: ->
      _this = this
      @container.tagsInput
        defaultText     : I18n.tags.placeholder
        width           : '100%'
        placeholderColor: '#999'
        autocomplete_url: _this.container.data('autocomplete')
        onAddTag        : _this.onAdd.bind(_this)

