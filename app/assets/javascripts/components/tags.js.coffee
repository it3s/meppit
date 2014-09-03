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
      onChange        : @onChange.bind(this)

  onAdd: (tag) ->
    lowercased = tag.toLowerCase()
    @replaceTag(tag, lowercased) unless tag is lowercased

  replaceTag: (tag, new_tag) ->
    @container.removeTag(tag)
    @container.addTag(new_tag) unless @container.tagExist(new_tag)

  onChange: (el) ->
    val = @container.val()
    taglist = if val.length > 0 then val.split(',') else []
    App.mediator.publish 'tags:changed', {identifier: @identifier, ctx: el, tags: taglist}
