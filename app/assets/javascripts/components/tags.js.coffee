#= require jquery.tagsinput

App.components.tags = ->
  initialize: ->
    @loadValues()
    @startPlugin()

  loadValues: () ->
    @container.val @attr.tags.join(',') if @attr.tags

  startPlugin: ->
    @container.tagsInput
      defaultText     : I18n.tags.placeholder
      width           : '100%'
      placeholderColor: '#999'
      autocomplete_url: @attr.autocomplete
      onAddTag        : @onAdd.bind(this)
      onRemoveTag     : @onRemove.bind(this)
      onChange        : @onChange.bind(this)

  setValue: (value) ->
    @container.importTags value

  getValue: ->
    @container.val?().split(',')

  onAdd: (tag) ->
    lowercased = tag.toLowerCase()
    @replaceTag(tag, lowercased) unless tag is lowercased
    @container.trigger 'change'
    App.mediator.publish 'tags:added', lowercased

  onRemove: (tag) ->
    @container.trigger 'change'
    App.mediator.publish 'tags:removed', tag

  onChange: (el, tag) ->
    App.mediator.publish 'tags:changed', @getValue()

  replaceTag: (tag, new_tag) ->
    @container.removeTag(tag)
    @container.addTag(new_tag) unless @container.tagExist(new_tag)
