App.components.autocomplete = ->
  attributes: ->
    target: $("##{@attr.name}-autocomplete")

  initialize: ->
    @container.autocomplete
      minLength: 2
      source:    @attr.url
      select:    @onSelect.bind(this)

  onSelect: (event, ui) ->
    value = ui.item?.id || ""
    target = @attr.target
    target.val(value)
    target.trigger 'change'
