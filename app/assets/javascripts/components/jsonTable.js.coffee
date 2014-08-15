#= require json.human

App.components.jsonTable = ->
  initialize: -> @container.append(JsonHuman.format @attr.jsonData)
