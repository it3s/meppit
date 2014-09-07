#= require jquery.tagsinput

App.components.tags = ->
  initialize: ->
    @loadValues()
    @startPlugin()

  loadValues: () ->
    @container.val @attr.tags.join(',')

  startPlugin: ->
    @container.tagsInput
      defaultText     : I18n.tags.placeholder
      width           : '100%'
      placeholderColor: '#999'
      autocomplete_url: @attr.autocomplete
      onAddTag        : @onAdd.bind(this)

  onAdd: (tag) ->
    lowercased = tag.toLowerCase()
    @replaceTag(tag, lowercased) unless tag is lowercased

  replaceTag: (tag, new_tag) ->
    @container.removeTag(tag)
    @container.addTag(new_tag) unless @container.tagExist(new_tag)
